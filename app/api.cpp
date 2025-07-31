#include "api.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
#ifndef QT_NO_PDF
#include <QPdfDocument>
#endif
#include <QBuffer>
#include <QPrinter>
#include <QPrinterInfo>
#include <QPainter>
#ifndef Q_OS_IOS
#include <QPrintDialog>
#endif
#include <QJsonArray>
#include <QDebug>
#include <QFontMetrics>
#include <QFile>
#include <QStandardPaths>
#include <networkresponse.h>
#include <QUrlQuery>
#include <QFile>
#include <QJsonDocument>
#include <QDir>

#include <qgumbonode.h>
#include <qgumbodocument.h>

#include <QThread>
#include <QNetworkDiskCache>
#include <QImage>
Api *Api::m_api;

Api::Api(QObject *parent) : QObject(parent)
{
    m_cachedManager = new NetworkAccessManager(this);
    QNetworkDiskCache* cache = new QNetworkDiskCache(m_cachedManager);
    QString cachePath = QStandardPaths::displayName(QStandardPaths::CacheLocation);
    cache->setCacheDirectory(cachePath);
    m_cachedManager->setCache(cache);
}

void Api::depositCash(const double &amount)
{
    QJsonObject data{{"amount",amount}};
    PosNetworkManager::instance()->post(QUrl("/accounts/depositCash"),data)->subscribe([this](NetworkResponse *res){
        emit depositCashResponseReceived(res->json().toObject());
    });
}

NetworkResponse * Api::processCustomBill(const QString &name, const int &vendorId, const QJsonArray &items)
{
    QJsonObject params;
    params["name"]=name;
    params["items"]=items;
    params["vendor_id"]=vendorId;

    return PosNetworkManager::instance()->post(QUrl("/vendorBill"),params);
}

NetworkResponse * Api::updateProduct(const QJsonObject &product)
{
    return PosNetworkManager::instance()->put(QUrl("/product"),product);
}


NetworkResponse * Api::updateProduct(const int &productId, const QString &name, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes)
{
    QJsonObject params{
        {"id",productId},
        {"name",name},
        {"list_price",listPrice},
        {"cost",cost},
        {"description",description},
        {"category_id",categoryId},
        {"taxes",taxes}
    };

    return PosNetworkManager::instance()->put(QUrl("/product"),params);
}

void Api::requestDashboard()
{
    PosNetworkManager::instance()->get(QUrl("/dashboard"))->subscribe(
                [this](NetworkResponse *res){
        emit dashboardReply(res->json("data").toObject());
    });
}
void Api::addCategory(const QString &name, const int &parentId)
{
    PosNetworkManager::instance()->post(QUrl("/categories/add"),QJsonObject{{"name",name},{"parent_id",parentId}})
            ->subscribe([this](NetworkResponse *res){
        emit categoryAddReply(res->json().toObject());
    });
}

void Api::removeCategory(const int &categoryId)
{
    PosNetworkManager::instance()->post(QUrl("/categories/remove"),QJsonObject{{"id",categoryId}})
            ->subscribe([this](NetworkResponse *res){
        emit categoryRemoveReply(res->json().toObject());
    });
}

void Api::barqReceipt(const int orderId)
{
#ifndef QT_NO_PDF
    PosNetworkManager::instance()->post(QUrl("/barq/receipt"),QJsonObject{{"order_id",orderId}})
            ->subscribe([this](NetworkResponse *res){


        qDebug()<<"res status:" << res->status();

        QByteArray pdf=res->binaryData();
        QBuffer *buffer=new QBuffer(&pdf);
        buffer->open(QIODevice::ReadOnly);
        QPdfDocument *doc=new QPdfDocument();
        connect(doc,&QPdfDocument::statusChanged,[this,doc](QPdfDocument::Status status){
            if(status!=QPdfDocument::Status::Ready)
                return;

            QPrinter printer;
            printer.setPrinterName(AppSettings::instance()->receiptPrinter());

            QPageSize pageSize=QPageSize(AppSettings::pageSizeFromString(AppSettings::instance()->receiptPaperSize()));

            printer.setPageSize(pageSize);
            printer.setPageMargins(QMarginsF(0,0,0,0));
            printer.setCopyCount(AppSettings::instance()->externalReceiptCopies());
#if QT_VERSION < QT_VERSION_CHECK(6,4,1)
            QImage image=doc->render(0,doc->pageSize(0).toSize().scaled(printer.width(),printer.width()*2,Qt::KeepAspectRatio));
#else
            QImage image=doc->render(0,pageSize.sizePixels(600));
#endif


            QImage white(image.size(),image.format());
            QPainter pt(&white);
            pt.fillRect(white.rect(),Qt::white);
            pt.drawImage(QPoint(0,0),image);
            pt.end();
            QPainter painter(&printer);
            painter.drawImage(QRect(0,0,printer.width(),printer.height()),image);
            painter.end();

        });

        doc->load(buffer);
    });
#endif
}

void Api::adjustStock(const int productId, const int newQty, const QString &reason)
{
    QJsonObject params{
        {"product_id",productId},
        {"new_qty",newQty},
        {"reason",reason},

    };

    PosNetworkManager::instance()->post(QUrl("/product/adjustStock"),params)->subscribe([this](NetworkResponse *res){
        emit adjustStockReply(res->json().toObject());
    });
}

bool Api::bulckStockAdjustment(const QUrl &url)
{
    QFile file(url.toLocalFile());
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return false;

    QTextStream in(&file);
    QString line=in.readLine();

    QJsonArray array;
    while(!line.isNull()){
        QStringList columns=line.split(',');
        //qDebug()<<"columns size: "<<columns.size();
            qDebug()<<"Stock: " <<columns.value(1) << " Actual: " << columns.value(2);
            QString name=columns.value(0);
            int stock=columns.value(1).toInt();
            bool ok=false;
            int actual=columns.value(2).toInt(&ok);
            if(ok){

                int difference=actual-stock;
                if(difference!=0){
                    array << QJsonObject{{"name",name},{"difference",difference}};

                }


            }



        line=in.readLine();
    }

    QJsonObject payload{{"data",array},{"reason","bulck adjustment"}};

    PosNetworkManager::instance()->post(QUrl("/products/adjustStockBulck"),payload)->subscribe(
                [this](NetworkResponse *res){
        qDebug()<<res->json();
        emit bulckStockAdjustmentReply(res->json().toObject());

    });

    return true;

}

void Api::returnBill(const int billId, const QJsonArray &items)
{
    PosNetworkManager::instance()->post(QUrl("/vendors/bills/return"),QJsonObject{{"bill_id",billId},
                                                                            {"items",items}})->subscribe([this](NetworkResponse *res){
        emit billReturnReply(res->json().toObject());
    });
}

void Api::generateImages(const QJsonObject &data)
{
//    return;
    QString savePath=data["save_path"].toString();
    bool includePrice=data["include_price"].toBool();

    QUrl url=savePath;
    savePath=url.toLocalFile();
    QDir().mkpath(savePath+"/products/single");
    PosNetworkManager::instance()->post(QUrl("/reports/catalogue"),data)->subscribe(
                [this,savePath,includePrice](NetworkResponse *res){
        NetworkAccessManager *mgr= new NetworkAccessManager(); //allocating it on the stack causes a crash
        QList<QImage> images;
        //QString desktop=QStandardPaths::standardLocations(QStandardPaths::DesktopLocation).value(0);
        QJsonArray products=res->json("data").toArray();
        for(QJsonValue product : products){

                    QString productName=QString::number(product["name2"].toInt());
                     QString productPrice=QString::number(product["list_price"].toDouble()/1000);
                     productPrice.append("\nالف دينار");
                    //QString productPrice="15 \nk Dinar";

                    //textOption.setTextDirection(Qt::RightToLeft);
                    QString thumb=product["thumb"].toString();
                    thumb=thumb.left(thumb.lastIndexOf("_thumbnail"));
                    thumb+=".jpg";


                    NetworkResponse *res=mgr->get(thumb);
                    res->waitForFinished();

                    QImage image = QImage::fromData(res->binaryData());
                    QPainter painter(&image);
                    painter.setRenderHints(QPainter::SmoothPixmapTransform | QPainter::Antialiasing | QPainter::TextAntialiasing);
                    painter.setBrush(Qt::white);
                    painter.setPen(Qt::white);

                    QFont font;
                    font.setPixelSize(80);
                    font.setBold(true);
                    painter.setFont(font);




                    QFontMetrics metrics(font);
                    QRect rect=QRect(QPoint(0,0),metrics.size(0,productName)).marginsAdded(QMargins(15,15,15,15));



//                    rect.moveTo(QPoint((image.width()-rect.width())/2,image.height()-rect.height()));

                    float offset=includePrice? 0.85 : 0.95;
                    rect.moveTo(image.width()*0.95-rect.width(),image.height()*offset-rect.height());

                    painter.setBrush(QColor(0,0,0,125));
                    painter.drawRoundedRect(rect,30,30);
                    painter.setBrush(Qt::white);
                    painter.drawText(rect,productName,QTextOption(Qt::AlignCenter));


                    if(includePrice){
                        font.setFamily("STV");
                        font.setPixelSize(60);
                        painter.setFont(font);
                        QTextOption textOption(Qt::AlignCenter);
                        textOption.setWrapMode(QTextOption::WordWrap);
                        metrics=QFontMetrics(font);
                        rect=QRect(QPoint(0,0),metrics.size(0,productPrice)).marginsAdded(QMargins(15,15,15,15));
                        rect.moveTo(image.width()*0.95-rect.width(),image.height()*0.95-rect.height());
                        painter.setBrush(QColor(0,0,0,125));
                        painter.drawRoundedRect(rect,30,30);
                        painter.setBrush(Qt::white);
                        painter.drawText(rect,productPrice,textOption);
                    }

                    painter.end();
                    images << image;
                    qDebug()<<image.save(QString("%1/products/single/%2.jpg").arg(savePath).arg(productName));
                    //return;

                    res->deleteLater();

        }

        for(int i=0; i<images.size(); i+=9){
            QImage image(1340*3,1785*3,QImage::Format_RGB32);
            image.fill(Qt::white);
            int row=0;
            QPainter painter(&image);
            for(int x=0; x<9; x+=3){
                for(int y=0; y<3; y++){
                    QImage unit = images.value(i+x+y);
                    painter.drawImage(QRect(QPoint(1340*y,1785*row),unit.size()),unit);
                }
                row++;
            }
            painter.end();
            qDebug()<<image.save(QString("%1/products/%2.jpg").arg(savePath).arg(i));
        }

        mgr->deleteLater();
    });
}

NetworkResponse * Api::addVendor(const QJsonObject &data)
{
    return PosNetworkManager::instance()->post(QUrl("/vendors/add"),data);
}


Api *Api::instance()
{
    if(!m_api)
        m_api=new Api();

    return m_api;
}


void Api::returnOrder(const int &orderId, const QJsonArray items)
{
    QJsonObject params;
    params["order_id"]=orderId;
    params["items"]=items;
    PosNetworkManager::instance()->post(QUrl("/orders/return"),params)->subscribe([this](NetworkResponse *res){

        emit returnOrderResponse(res->json().toObject());
    });
}


void Api::returnableItems(const int &orderId)
{
    QJsonObject params;
    params["order_id"]=orderId;
    PosNetworkManager::instance()->post(QUrl("/order/returnableItems"),params)->subscribe([this](NetworkResponse *res){

        emit returnableItemsResponse(res->json().toObject());
    });
}


void Api::addCustomer(const QString name, const QString firstName, const QString lastName, const QString email, const QString phone, const QString address)
{
    addCustomer(QJsonObject{{"name",name},
                            {"first_name",firstName},
                            {"last_name",lastName},
                            {"email",email},
                            {"phone",phone},
                            {"address",address}});
}

NetworkResponse *  Api::addCustomer(const QJsonObject &data)
{
    return PosNetworkManager::instance()->post(QUrl("customer"),data);
}

NetworkResponse * Api::updateCustomer(const QJsonObject &data)
{
    return PosNetworkManager::instance()->put(QUrl("/customer"),data);
}

NetworkResponse * Api::updateVendor(const QJsonObject &data)
{
    return PosNetworkManager::instance()->put(QUrl("/vendor"),data);
}


NetworkResponse * Api::payBill(const int &vendorBillId)
{
    return PosNetworkManager::instance()->post(QUrl("/vendors/bills/pay"),QJsonObject{{"billId",vendorBillId}});
}

void Api::createBill(const int &vendorId, const QJsonArray &products)
{
    QJsonObject params;
    params["products"]=products;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post(QUrl("/product/purchaseProduct"),params)->subscribe(
                [this](NetworkResponse *res){
        emit createBillReply(res->json().toObject());
    });
}

NetworkResponse * Api::addUser(const QJsonObject &data)
{
    return PosNetworkManager::instance()->post(QUrl("/user"),data);
}

NetworkResponse * Api::updateUser(const QJsonObject &data)
{
    return PosNetworkManager::instance()->put(QUrl("/user"),data);
}

NetworkResponse *Api::deleteUser(const int userId)
{
    QUrl url("/user");
    url.setQuery(QUrlQuery{{"id",QString::number(userId)}});

    return PosNetworkManager::instance()->deleteResource(url);
}

NetworkResponse *Api::addTax(const QJsonObject &data)
{
    return PosNetworkManager::instance()->post(QUrl("/tax"),data);
}

NetworkResponse *Api::updateTax(const QJsonObject &data)
{
    return PosNetworkManager::instance()->put(QUrl("/tax"),data);

}

NetworkResponse *Api::removeTax(const int taxId)
{
    QUrl url("/tax");
    url.setQuery(QUrlQuery{{"id",QString::number(taxId)}});

    return PosNetworkManager::instance()->deleteResource(url);
}




NetworkResponse *Api::setProductAttributes(const int &productId, const QJsonArray &attributes)
{
    return PosNetworkManager::instance()->put(QUrl("product/attributes"),QJsonObject{
                                                                          {"product_id",productId},
                                                                          {"attributes",attributes}
                                                              });

}

NetworkResponse *Api::addProduct(const QJsonObject &product)
{
    return PosNetworkManager::instance()->post(QUrl("/product"),product);
}

bool Api::addProducts(const QUrl &url)
{
    QFile file(url.toLocalFile());
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)){
        qWarning()<<"error in opening file";
        return false;
    }

    QTextStream in(&file);
    QString line=in.readLine();
    QStringList headers=line.split(',');
    QSet<QString> headersSet(headers.begin(),headers.end());
    qDebug()<<"Headers: " << headersSet;

    //check headers here !
    QSet<QString> checkList{"name","list_price","cost","category","barcode","type","parent","description","costing_method"};
    QStringList types{"storable","service","consumable"};
    QStringList costingMethods{"FIFO","LIFO","AVCO"};

    if(!headersSet.contains(checkList)){
        qWarning()<<"invalid header set";

        return false;
    }
    //anything else aside from the checklist will be treated as an attribute
    //processing the file on the front end will reduce traffic on the backend, and waiting time too


    QStringList attributes=headers;
    for(const QString &str : checkList){
        attributes.removeAll(str);
    }
    QJsonArray array;
    line=in.readLine();

    while(!line.isEmpty()){
        QJsonObject product;
        QStringList columns=line.split(',');
        //qDebug()<<"columns size: "<<columns.size();
        product["name"]=columns.value(headers.indexOf("name"));
        product["list_price"]=columns.value(headers.indexOf("list_price")).toDouble();
        product["cost"]=columns.value(headers.indexOf("cost")).toDouble();
        product["category"]=columns.value(headers.indexOf("category"));
        product["barcode"]=columns.value(headers.indexOf("barcode"));
        product["type"]=columns.value(headers.indexOf("type"));
        qDebug()<<"columns: " << columns;
        if(!types.contains(product["type"].toString())){
            qDebug()<<"product type: " << product["type"].toString();
            qWarning()<<"invalid product type";
            return false;
        }
        product["parent"]=columns.value(headers.indexOf("parent"));
        product["description"]=columns.value(headers.indexOf("description"));
        product["costing_method"]=columns.value(headers.indexOf("costing_method"));
        if(!costingMethods.contains(product["costing_method"].toString())){
            qWarning()<<"invalid costing method";
            return false;
        }

        QJsonArray attr;
        for(auto str : attributes){

            attr << QJsonObject{{"attribute_id",str},{"value",columns.value(headers.indexOf(str))},{"type","text"}};
        }
        product["attributes"]=attr;

        array << product;

        line=in.readLine();
    }


    QJsonObject payload{{"data",array},{"reason","bulck adjustment"}};

    PosNetworkManager::instance()->post(QUrl("product/bulckAdd"),payload)->subscribe(
        [this](NetworkResponse *res){
            qDebug()<<res->json();
            emit bulckStockAdjustmentReply(res->json().toObject());

        });

    return true;

}

NetworkResponse *Api::nextVersion()
{
    int version=AppSettings::version();
    QString software="pos-fe";
    QString platform=AppSettings::platform();

    QUrl url("https://software.sadeq.shop/next");


    url.setQuery(QUrlQuery{{"version",QString::number(version)},{"software",software},{"platform",platform}});


    return PosNetworkManager::instance()->get(url);

}

NetworkResponse *Api::addSheinOrder(const QUrl &fileUrl, const bool buy)
{

    qDebug()<<fileUrl.toLocalFile();
    QFile file(fileUrl.toLocalFile());

    qDebug()<<"File open: " << file.open(QIODevice::ReadOnly | QIODevice::Text);


    QFileInfo info(fileUrl.toLocalFile());

    QJsonDocument doc;
    if(info.suffix()=="html"){
        QTextStream in(&file);
        QString line;
        while(!in.atEnd()){
                line = file.readLine();
                if(line.contains(R"(order: {"billno")")){
                    break;
                }
        }
        if(!line.isEmpty()){
                line.removeLast();
                line.removeLast();

                int index=line.indexOf(R"(order: {"billno)");
                line.remove(0,index);
                line.remove("order: ");
        }

        doc=QJsonDocument::fromJson(line.toUtf8());
    }else{
        //if it's a json file the extract the order object for now
        doc=QJsonDocument::fromJson(file.readAll());
        QJsonObject order=doc.object()["order"].toObject();
        doc=QJsonDocument(order);
    }

    file.close();
    return PosNetworkManager::instance()->post(QUrl("/shein/addOrder"),QJsonObject{{"data",doc.object()},{"buy",buy}});

//    return PosNetworkManager::instance()->post(QUrl("/shein/addOrder"),QJsonObject{{"data",doc["_allOrderGoodsList"].toArray()}});
}

bool Api::addSheinOrders(const QUrl &folderUrl, const bool buy)
{
    QDir dir(folderUrl.toLocalFile());

    if (!dir.exists()) {
        qDebug() << "Directory does not exist!";
        return false;
    }


    for(const QFileInfo &fileInfo : dir.entryInfoList({"*.json"},QDir::Files | QDir::NoDotAndDotDot,QDir::Time)){


        QFile file(fileInfo.absoluteFilePath());
        file.open(QIODevice::ReadOnly);
        QJsonDocument doc=QJsonDocument::fromJson(file.readAll());
        QJsonObject order=doc.object()["order"].toObject();
        doc=QJsonDocument(order);

        file.close();

        NetworkResponse *res=PosNetworkManager::instance()->post(QUrl("/shein/addOrder"),QJsonObject{{"data",doc.object()},{"buy",buy}});
        res->waitForFinished();

        qDebug()<<res->json();


    }

    return true;
}



NetworkResponse *Api::get(const QUrl &url)
{
    return PosNetworkManager::instance()->get(url);
}

NetworkResponse *Api::post(const QUrl &url, const QJsonObject data)
{
    return PosNetworkManager::instance()->post(url,data);

}

NetworkResponse *Api::identity()
{
    return PosNetworkManager::instance()->get(QUrl("/identity"));
}

NetworkResponse *Api::postIdentity(QJsonObject data)
{
    //we will modify image inside data

    QUrl logoFile=data["identity_logo"].toString();

    QFile file(logoFile.toLocalFile());
    file.open(QIODevice::ReadOnly);

    QByteArray fileData=file.readAll();
    file.close();
    data["identity_logo"]=QString(fileData.toBase64());

    return PosNetworkManager::instance()->post(QUrl("/identity"),data);

}

NetworkResponse *Api::postReceipt(QJsonObject data)
{

    QUrl logoFile=data["receipt_logo"].toString();
    qDebug()<<"original data: " <<data;
    QFile file(logoFile.toLocalFile());
    file.open(QIODevice::ReadOnly);

    QByteArray fileData=file.readAll();
    file.close();
    data["receipt_logo"]=QString(fileData.toBase64());
    qDebug()<<"data: " << data;
    return PosNetworkManager::instance()->post(QUrl("/receipt"),data);

}

NetworkResponse *Api::receipt()
{
    return PosNetworkManager::instance()->get(QUrl("/receipt"));
}

NetworkResponse *Api::config()
{
    return PosNetworkManager::instance()->get(QUrl("/config"));
}

NetworkResponse *Api::removeAttribute(const QString &id)
{
    QUrl url("/productAttribute");
    url.setQuery(QUrlQuery{{"id",id}});

    return PosNetworkManager::instance()->deleteResource(url);
}

NetworkResponse *Api::removeDraftOrder(const int id)
{
    QUrl url("/draftOrder");
    url.setQuery(QUrlQuery{{"id",QString::number(id)}});

    return PosNetworkManager::instance()->deleteResource(url);
}

NetworkResponse *Api::newPosSession()
{
    return PosNetworkManager::instance()->get(QUrl("/posssession/request"));
}

NetworkResponse *Api::requestNewCart()
{
    return PosNetworkManager::instance()->get(QUrl("/pos/cart/request"));
}

NetworkResponse *Api::printOrders(const QJsonArray ids)
{
    return PosNetworkManager::instance()->post(QUrl("/orders/print"),QJsonObject{{"ids",ids}});

}


void Api::scrapeImages()
{
    NetworkAccessManager mgr;

    QJsonObject params;
    params["filter"]=QJsonObject{{"parent_id",0}};
    if(true){
        params["page"]=1;
        params["count"]=100;
    }
    params["sortBy"]="id";
    params["direction"]="desc";

    NetworkResponse *r=this->post(QUrl("/products"),params);
    r->waitForFinished();
    QJsonArray masters=r->json("data").toArray();
    // qDebug()<<r->json();
    mgr.setRedirectPolicy(QNetworkRequest::RedirectPolicy::SameOriginRedirectPolicy);
    for(const QJsonValue &value: masters){
        QJsonObject master = value.toObject();

        QString sku;

        QJsonArray attributes=master["attributes"].toArray();

        for(int j=0; j<attributes.size(); j++){
            QJsonObject attribute=attributes.at(j).toObject();
            QString attributeId=attribute["attribute_id"].toString();

            if(attributeId=="external_sku"){
                sku=attribute["value"].toString();
                break;
            }

        }

        qDebug()<<"sku: " << sku;


        NetworkResponse *res=mgr.get(QString("https://shein.com/pdsearch/%1").arg(sku));
        res->waitForFinished();
        qDebug()<<"Res status: " <<res->status();
        QGumboDocument doc=QGumboDocument::parse(res->binaryData());
        QGumboNode root=doc.rootNode();
        QGumboNodes nodes=root.getElementsByClassName("S-product-card__img-container j-expose__product-item-img S-product-card__img-container_mask");



        QString tmp=QStandardPaths::standardLocations(QStandardPaths::DesktopLocation).value(0);

        QFile f(tmp+"/tmp/test.html");
        f.open(QIODevice::WriteOnly);
        f.write(res->binaryData());
        f.close();
        qDebug()<<"nodes size: "<<root.childNodes().size();
        if(!nodes.size()){
            qDebug()<<"skipping...";
            return;
            continue;
        }

        QGumboNode link=nodes.front();

        QString href=link.getAttribute("href");

        href.prepend("https://ar.shein.com");

        NetworkResponse *res2=mgr.get(href);
        res2->waitForFinished();
        QByteArray html=res2->binaryData();

        QByteArray script=html.mid(html.indexOf("productIntroData: "));

        script=script.mid(script.indexOf('{'));
        script=script.left(script.lastIndexOf("var GB_S_SHIPPING_COST"));
        script=script.left(script.lastIndexOf("\n        abt: ")-1);
        script=script.trimmed();

        //qDebug()<<script;

        QJsonParseError error;

        QJsonDocument jsonDoc=QJsonDocument::fromJson(script,&error);


        QStringList images;
        QJsonObject goodsImgs=jsonDoc.object()["goods_imgs"].toObject();
        QJsonObject mainImg=goodsImgs["main_image"].toObject();
        images << mainImg["origin_image"].toString().prepend("https:");
        QJsonArray detailImages=goodsImgs["detail_image"].toArray();

        for(auto img: detailImages){
            images << img.toObject()["origin_image"].toString().prepend("https:");
        }


        QDir().mkpath(tmp+QString("/tmp/shein/%1").arg(sku));
        for(int i=0; i<images.count(); i++){

            QString img=images.at(i);
            NetworkResponse *imgRes=mgr.get(img);
            imgRes->waitForFinished();
            QImage image=QImage::fromData(imgRes->binaryData());
            qDebug()<<"save: "<<image.save(QString("/tmp/shein/%1/%2.jpg").arg(sku).arg(i));
            QThread::currentThread()->sleep(1);
        }


        QThread::currentThread()->sleep(1);
        break;
    }
}

QImage Api::cachedImage(const QUrl &url)
{
    NetworkResponse  *res=m_cachedManager->get(url);
    res->waitForFinished();
    return QImage::fromData(res->binaryData());
}

NetworkResponse *Api::cancelOrder(const int id)
{
    QUrl url("/order/cancel");
    url.setQuery(QUrlQuery{{"id",QString::number(id)}});

    return PosNetworkManager::instance()->get(url);
}

