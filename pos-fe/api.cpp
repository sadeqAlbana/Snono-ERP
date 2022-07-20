#include "api.h"
#include <QJsonObject>
#include "posnetworkmanager.h"
#ifndef Q_OS_ANDROID
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
    qDebug()<<product;
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
#ifndef Q_OS_ANDROID

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
        qDebug()<<"columns size: "<<columns.size();
        line=in.readLine();

    }


}

void Api::generateImages()
{
    return;
    PosNetworkManager::instance()->post("/reports/catalogue",QJsonObject{})->subcribe(
                [this](NetworkResponse *res){
        NetworkManager mgr;
        QList<QImage> images;

        QJsonArray products=res->json("data").toArray();
        for(QJsonValue product : products){

                    QString productName=QString::number(product["name2"].toInt());
                    QString productPrice=QString::number(product["list_price"].toDouble());
                    QString thumb=product["thumb"].toString();

                    QImage image = QImage::fromData(mgr.getSynch(thumb).binaryData());
                    QPainter painter(&image);
                    painter.setBrush(Qt::white);
                    painter.setPen(Qt::white);
                    QFont font;
                    font.setPixelSize(40);

                    painter.setFont(font);



                    QFontMetrics metrics(font);
                    QRect rect=metrics.boundingRect(productName);

//                    rect.moveTo(QPoint((image.width()-rect.width())/2,image.height()-rect.height()));
                    rect.moveTo(0,0);

                    painter.fillRect(rect,Qt::black);
                    painter.drawText(rect,productName,QTextOption(Qt::AlignCenter));

                    rect=metrics.boundingRect(productPrice);
                    rect.moveTo(image.width()-rect.width(),image.height()-rect.height());
                    painter.fillRect(rect,Qt::black);
                    painter.drawText(rect,productPrice,QTextOption(Qt::AlignCenter));
                    painter.end();
                    images << image;
                    //qDebug()<<image.save(QString("C:/users/sadeq/Desktop/products/%1.jpg").arg(productName));
                    //return;


        }

        for(int i=0; i<images.size(); i+=9){
            QImage image(219*3,293*3,QImage::Format_RGB32);
            image.fill(Qt::white);
            int row=0;
            QPainter painter(&image);
            for(int x=0; x<9; x+=3){
                for(int y=0; y<3; y++){
                    QImage unit = images.value(i+x+y);
                    painter.drawImage(QRect(QPoint(219*y,293*row),unit.size()),unit);
                }
                row++;
            }
            painter.end();
            image.save(QString("C:/users/sadeq/Desktop/products/%1.jpg").arg(i));
        }
    });
}


Api *Api::instance()
{
    if(!m_api)
        m_api=new Api();

    return m_api;
}
