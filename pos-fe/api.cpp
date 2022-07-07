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


Api *Api::instance()
{
    if(!m_api)
        m_api=new Api();

    return m_api;
}
