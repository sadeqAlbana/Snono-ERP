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
Api *Api::m_api;
Api::Api(QObject *parent) : QObject(parent)
{

}

void Api::depositCash(const double &amount)
{
    QJsonObject data{{"amount",amount}};
    PosNetworkManager::instance()->post("/accounts/depositCash",data)->subcribe([this](NetworkResponse *res){
        emit depositCashResponseReceived(res->json().toObject());
    });
}

void Api::processCustomBill(const QString &name, const int &vendorId, const QJsonArray &items)
{
    QJsonObject params;
    params["name"]=name;
    params["items"]=items;
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post("/vendors/bills/add",params)->subcribe(
                [this](NetworkResponse *res){
        emit processCustomBillResponse(res->json().toObject());
    });
}

void Api::updateProduct(const QJsonObject &product)
{
    PosNetworkManager::instance()->post("/products/update",product)->subcribe(
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

    PosNetworkManager::instance()->post("/products/update",params)->subcribe(
                [this](NetworkResponse *res){
        emit updateProductReply(res->json().toObject());
    });
}

void Api::requestDashboard()
{
    PosNetworkManager::instance()->get("/dashboard")->subcribe(
                [this](NetworkResponse *res){
        emit dashboardReply(res->json("data").toObject());
    });
}
void Api::addCategory(const QString &name, const int &parentId)
{
    PosNetworkManager::instance()->post("/categories/add",QJsonObject{{"name",name},{"parent_id",parentId}})
            ->subcribe([this](NetworkResponse *res){
        emit categoryAddReply(res->json().toObject());
    });
}

void Api::removeCategory(const int &categoryId)
{
    PosNetworkManager::instance()->post("/categories/remove",QJsonObject{{"id",categoryId}})
            ->subcribe([this](NetworkResponse *res){
        emit categoryRemoveReply(res->json().toObject());
    });
}

void Api::barqReceipt(const QString &reference)
{
#ifndef QT_NO_PDF
    qDebug()<<"Reference: " << reference;
    PosNetworkManager::instance()->post("/barq/receipt",QJsonObject{{"pos_order_reference",reference}})
            ->subcribe([this](NetworkResponse *res){
        QByteArray pdf=res->binaryData();
        QBuffer *buffer=new QBuffer(&pdf);
        buffer->open(QIODevice::ReadOnly);
        QPdfDocument *doc=new QPdfDocument();
        connect(doc,&QPdfDocument::statusChanged,[this,doc](QPdfDocument::Status status){
            if(status!=QPdfDocument::Ready)
                return;

            //QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
            //QPrinter printer;
            QPrinter printer(QPrinterInfo::defaultPrinter(),QPrinter::HighResolution);
//            qDebug()<<"printer width:" << printer.width();
//            qDebug()<<"printer height:" << printer.height();
//            qDebug()<<"printer widthmm:" << printer.widthMM();
//            qDebug()<<"printer heightmm:" << printer.heightMM();
            printer.setPageSize(QPageSize::A5);
            printer.setPageMargins(QMarginsF(0,0,0,0));
            printer.setCopyCount(3);

                QImage image=doc->render(0,doc->pageSize(0).toSize().scaled(printer.width(),printer.width()*2,Qt::KeepAspectRatio));

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

    PosNetworkManager::instance()->post("/products/adjustStock",params)->subcribe([this](NetworkResponse *res){
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
        if(columns.value(2)=="No"){
            qDebug()<<"Stock: " <<columns.value(1) << " Actual: " << columns.value(3);
            QString name=columns.value(0);
            int stock=columns.value(1).toInt();
            int actual=columns.value(3).toInt();
            int difference=actual-stock;
            array << QJsonObject{{"name",name},{"difference",difference}};
        }

        line=in.readLine();
    }

    QJsonObject payload{{"data",array},{"reason","bulck adjustment"}};

    PosNetworkManager::instance()->post("/products/adjustStockBulck",payload)->subcribe(
                [this](NetworkResponse *res){
        qDebug()<<res->json();
        emit bulckStockAdjustmentReply(res->json().toObject());

    });

    return true;

}

void Api::generateImages()
{
    return;
    PosNetworkManager::instance()->post("/reports/catalogue",QJsonObject{{"start_id",6}})->subcribe(
                [this](NetworkResponse *res){
        NetworkManager mgr;
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


                    QImage image = QImage::fromData(mgr.getSynch(thumb).binaryData());
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


Api *Api::instance()
{
    if(!m_api)
        m_api=new Api();

    return m_api;
}
