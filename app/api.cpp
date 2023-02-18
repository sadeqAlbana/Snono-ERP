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
#include <QPrintDialog>
#include <QJsonArray>
#include <QDebug>
#include <QFontMetrics>
#include <QFile>
#include <QStandardPaths>
#include <networkresponse.h>
Api *Api::m_api;
Api::Api(QObject *parent) : QObject(parent)
{

}

void Api::depositCash(const double &amount)
{
    QJsonObject data{{"amount",amount}};
    PosNetworkManager::instance()->post(QUrl("/accounts/depositCash"),data)->subscribe([this](NetworkResponse *res){
        emit depositCashResponseReceived(res->json().toObject());
    });
}

void Api::processCustomBill(const QString &name, const int &vendorId, const QJsonArray &items)
{
    QJsonObject params;
    params["name"]=name;
    params["items"]=items;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post(QUrl("/vendors/bills/add"),params)->subscribe(
                [this](NetworkResponse *res){
        emit processCustomBillResponse(res->json().toObject());
    });
}

void Api::updateProduct(const QJsonObject &product)
{
    PosNetworkManager::instance()->post(QUrl("/products/update"),product)->subscribe(
                [this](NetworkResponse *res){
        emit updateProductReply(res->json().toObject());
    });
}


void Api::updateProduct(const int &productId, const QString &name, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes)
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

    PosNetworkManager::instance()->post(QUrl("/products/update"),params)->subscribe(
                [this](NetworkResponse *res){
        emit updateProductReply(res->json().toObject());
    });
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
    PosNetworkManager::instance()->post(QUrl("/barq/receipt"),QJsonObject{{"pos_order_id",orderId}})
            ->subscribe([this](NetworkResponse *res){
        QByteArray pdf=res->binaryData();
        QBuffer *buffer=new QBuffer(&pdf);
        buffer->open(QIODevice::ReadOnly);
        QPdfDocument *doc=new QPdfDocument();
        connect(doc,&QPdfDocument::statusChanged,[this,doc](QPdfDocument::Status status){
            if(status!=QPdfDocument::Status::Ready)
                return;


            QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);

            printer.setPageSize(QPageSize::A5);
            printer.setPageMargins(QMarginsF(0,0,0,0));
            printer.setCopyCount(AppSettings::instance()->externalReceiptCopies());

#if QT_VERSION < QT_VERSION_CHECK(6,4,1)
                QImage image=doc->render(0,doc->pageSize(0).toSize().scaled(printer.width(),printer.width()*2,Qt::KeepAspectRatio));
#else
            QImage image=doc->render(0,doc->pagePointSize(0).toSize().scaled(printer.width(),printer.width()*2,Qt::KeepAspectRatio));
#endif
                QPainter painter(&printer);
                painter.drawImage(QPoint(0,0),image);
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

    PosNetworkManager::instance()->post(QUrl("/products/adjustStock"),params)->subscribe([this](NetworkResponse *res){
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

void Api::generateImages()
{
//    return;
    qDebug()<<"called";
    PosNetworkManager::instance()->post(QUrl("/reports/catalogue"),QJsonObject{{"start_id",2353}})->subscribe(
                [this](NetworkResponse *res){
        NetworkAccessManager mgr;
        QList<QImage> images;
        QString desktop=QStandardPaths::standardLocations(QStandardPaths::DesktopLocation).value(0);
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


                    NetworkResponse *res=mgr.get(thumb);
                    res->waitForFinished();

                    QImage image = QImage::fromData(res->binaryData());
                    QPainter painter(&image);
                    painter.setRenderHint(QPainter::SmoothPixmapTransform);
                    painter.setBrush(Qt::white);
                    painter.setPen(Qt::white);

                    QFont font;
                    font.setPixelSize(140);
                    font.setBold(true);
                    painter.setFont(font);




                    QFontMetrics metrics(font);
                    QRect rect=QRect(QPoint(0,0),metrics.size(0,productName)).marginsAdded(QMargins(20,20,20,20));



//                    rect.moveTo(QPoint((image.width()-rect.width())/2,image.height()-rect.height()));
                    rect.moveTo(image.width()*0.95-rect.width(),image.height()*0.05);
                    painter.setBrush(Qt::black);
                    painter.drawRoundedRect(rect,40,40);
                    painter.setBrush(Qt::white);
                    painter.drawText(rect,productName,QTextOption(Qt::AlignCenter));


                    font.setFamily("STV");
                    painter.setFont(font);
                    QTextOption textOption(Qt::AlignCenter);
                    textOption.setWrapMode(QTextOption::WordWrap);
                    rect=QRect(QPoint(0,0),metrics.size(0,productPrice)).marginsAdded(QMargins(20,20,20,20));
                    rect.moveTo(image.width()*0.95-rect.width(),image.height()*0.95-rect.height());
                    painter.setBrush(Qt::black);
                    painter.drawRoundedRect(rect,20,20);
                    painter.setBrush(Qt::white);
                    painter.drawText(rect,productPrice,textOption);
                    painter.end();
                    images << image;
                    qDebug()<<image.save(QString("%1/products/single/%2.jpg").arg(desktop).arg(productName));
                    //return;


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
            qDebug()<<image.save(QString("%1/products/%2.jpg").arg(desktop).arg(i));
        }
    });
}

void Api::addVendor(const QJsonObject &data)
{
    PosNetworkManager::instance()->post(QUrl("/vendors/add"),data )
            ->subscribe([this](NetworkResponse *res){

        emit vendorAddReply(res->json().toObject());
    });
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

void Api::addCustomer(const QJsonObject &data)
{
    PosNetworkManager::instance()->post(QUrl("/customers/add"),data)->subscribe(
                [this](NetworkResponse *res){
        emit addCustomerReply(res->json().toObject());
    });
}

void Api::updateVendor(const QJsonObject &data)
{
    PosNetworkManager::instance()->put(QUrl("/vendors"),data)->subscribe(
                [this](NetworkResponse *res){
        emit updateVendorReply(res->json().toObject());
    });
}



void Api::payBill(const int &vendorBillId)
{
    PosNetworkManager::instance()->post(QUrl("/vendors/bills/pay"),QJsonObject{{"billId",vendorBillId}})

            ->subscribe([this](NetworkResponse *res){

        emit payBillReply(res->json().toObject());
    });
}

void Api::createBill(const int &vendorId, const QJsonArray &products)
{
    QJsonObject params;
    params["products"]=products;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post(QUrl("/products/purchaseProduct"),params)->subscribe(
                [this](NetworkResponse *res){
        emit createBillReply(res->json().toObject());
    });
}

