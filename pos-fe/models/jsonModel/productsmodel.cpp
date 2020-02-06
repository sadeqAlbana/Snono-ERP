#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
ProductsModel::ProductsModel(QObject *parent) : NetworkedJsonModel ("/products",parent)
{
    requestData();
}

//void ProductsModel::onTableRecieved(NetworkResponse *reply)
//{
//    QJsonArray data = reply->jsonObject().value("data").toArray();
//    QJsonArray array;

//    for(QJsonValue value : data){
//        QJsonObject product;
//        QJsonObject json=value.toObject();

//        product["name"]=json["name"];
//        product["list_price"]=json["list_price"];
//        product["barcode"]=json["barcode"];
//        array << product;
//    }
//    setupData(array);
//}

void ProductsModel::requestData()
{
    manager.get(url)->subcribe((NetworkedJsonModel *)this,&NetworkedJsonModel::onTableRecieved);
}

ColumnList ProductsModel::columns() const
{
    return ColumnList() <<
                           Column{"name","Name"} <<
                           Column{"barcode","Barcode"} <<
                           Column{"default_cost","Cost"} <<
                           Column{"qty","Stock","products_stocks"};
}
