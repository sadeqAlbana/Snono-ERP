#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
#include "../posnetworkmanager.h"
#include <QFile>
#include <QTextStream>
#include <authmanager.h>
#include <networkresponse.h>

ProductsModel::ProductsModel(QObject *parent) : AppNetworkedJsonModel ("/products",
                                                                       JsonModelColumnList(),parent)
{
    //requestData();

    JsonModelColumnList list{
    {"id",tr("ID")} ,
//    {"thumb",tr("Image"),QString(),"image"} ,
    {"name",tr("Name")} ,
    // {"sku",tr("SKU")} ,
//    {"size",tr("Size")} ,
    {"cost",tr("Cost"),QString(),false,"currency"} ,
//    {"current_cost","Current Cost",QString(), "currency"} ,
    {"qty",tr("Stock"),"products_stocks"} ,
    {"list_price",tr("List Price"),QString(),false,"currency"}};
    if(!AuthManager::instance()->hasPermission("prm_view_product_cost")){
        list.removeAt(2);
    }
    m_columns=list;
}

void ProductsModel::updateProduct(const int &productId, const QString &name, const QString &barcode, const double &listPrice, const double &cost, const QString &description, const int &categoryId, const QJsonArray &taxes)
{
    QJsonObject params{
        {"id",productId},
        {"name",name},
        {"barcode",barcode},
        {"list_price",listPrice},
        {"cost",cost},
        {"description",description},
        {"category_id",categoryId},
        {"taxes",taxes}
    };
    PosNetworkManager::instance()->post(QUrl("/products/update"),params)->subscribe(this,&ProductsModel::onUpdateProductReply);

}




void ProductsModel::updateProduct(const QJsonObject &product)
{
    PosNetworkManager::instance()->post(QUrl("/products/update"),product)->subscribe(this,&ProductsModel::onUpdateProductReply);
}

void ProductsModel::onUpdateProductReply(NetworkResponse *res)
{
    QJsonObject response=res->json().toObject();
    if(response["status"].toBool())
        this->requestData();

    emit productUpdateReply(response);
}

void ProductsModel::updateProductQuantity(const int &index, const double &newQuantity)
{
    QJsonObject product=jsonObject(index);
    QJsonObject params;
    params["product_id"]=product["id"];
    params["new_quantity"]=newQuantity;
    PosNetworkManager::instance()->post(QUrl("/products/updateQuantity"),params)->subscribe(this,&ProductsModel::onUpdateProductQuantityReply);
}

void ProductsModel::onUpdateProductQuantityReply(NetworkResponse *res)
{
    emit productQuantityUpdated(res->json().toObject());
}

void ProductsModel::purchaseStock(const int &productId, const double &qty, const int &vendorId)
{
    QJsonObject params;
    params["products"]=QJsonArray{QJsonObject{{"id",productId},{"qty",qty}}};
    params["vendor_id"]=vendorId;

    PosNetworkManager::instance()->post(QUrl("/vendorBill"),params)->subscribe(this,&ProductsModel::onPurchaseStockReply);

}

void ProductsModel::onPurchaseStockReply(NetworkResponse *res)
{
    emit stockPurchasedReply(res->json().toObject());
}

void ProductsModel::addProduct(const QString &name, const QString &barcode, const double &listPrice, const double &cost, const int &typeId, const QString &description, const int &categoryId, const QList<int> &taxes, const int &parentId)
{
    QJsonArray taxesArray;
    for(const int &tax : taxes){
        taxesArray.append(tax);
    }

    QJsonObject params{
        {"name",name},
        {"barcode",barcode},
        {"list_price",listPrice},
        {"cost",cost},
        {"type",typeId},
        {"description",description},
        {"taxes",taxesArray},
        {"category_id",categoryId},
        {"parent_id",parentId}

    };

    PosNetworkManager::instance()->post(QUrl("/products/add"),params)->subscribe([this](NetworkResponse *res){
        emit productAddReply(res->json().toObject());
    });
}

void ProductsModel::removeProduct(const int &productId)
{
    PosNetworkManager::instance()->post(QUrl("/products/remove"),QJsonObject{{"id",productId}})
            ->subscribe([this](NetworkResponse *res){
        emit productRemoveReply(res->json().toObject());
    });
}

QVariantMap ProductsModel::jsonMap(const int &row)
{
    return this->jsonObject(row).toVariantMap();
}

void ProductsModel::exportJson()
{
    QFile file("exported.csv");
    file.open(QIODevice::WriteOnly);

    QStringList keys;
    for(int i=0; i<columnCount(); i++){
        keys << headerData(i,Qt::Horizontal,Qt::EditRole).toString();
    }
    QString line=keys.join(',');
    //QTextStream stream(&file);
    //stream << line << Qt::endl;
    file.write(QByteArray(line.toUtf8()+'\n'));
    for(int row=0; row< rowCount(); row++){
        QString line;
        for(int column=0; column<columnCount(); column++){
            QVariant variant=this->data(index(row,column),Qt::DisplayRole);
            QString value=DataSerialization::serialize(variant);
//            if(column==indexOf("name")){
//                qDebug()<<value;
//            }
            if(value.isEmpty())
                value="N.A";
            line.append(value);
            if(column<columnCount()-1){
                line.append(',');
            }
        }

        //stream << line << Qt::endl;;
        file.write(QByteArray(line.toUtf8()+'\n'));

    }
    file.close();

}

QJsonArray ProductsModel::filterData(QJsonArray data)
{

    QStringList wanted;

    for(const QJsonValue &value: m_wantedColumns){
        wanted << value["id"].toString();
    }
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        QJsonArray attributes=product["attributes"].toArray();

        for(int j=0; j<attributes.size(); j++){
            QJsonObject attribute=attributes.at(j).toObject();
            attribute["type"]=attribute["attributes_attribute"].toObject()["type"];
            QString attributeId=attribute["attribute_id"].toString();

            attributes.replace(j,attribute);
            if(wanted.contains(attributeId)){
                product[attributeId]=attribute["value"];
            }
        }
        product["attributes"]=attributes;

        data.replace(i,product);
    }
    return data;
}

void ProductsModel::onTableRecieved(NetworkResponse *reply)
{
    if(m_wantedColumns.isEmpty()){
        this->m_wantedColumns=reply->json("attributes").toArray();
        for(const QJsonValue &value: m_wantedColumns){
            m_columns.append(JsonModelColumn{value["id"].toString(),value["name"].toString(),QString(),false,value["type"].toString()});
        }
    }
//    endResetModel();
    AppNetworkedJsonModel::onTableRecieved(reply);
}
