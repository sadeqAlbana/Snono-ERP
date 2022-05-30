#include "productsmodel.h"
#include "networkresponse.h"
#include <QJsonArray>
#include <posnetworkmanager.h>
#include <QFile>
#include <QTextStream>
ProductsModel::ProductsModel(QObject *parent) : AppNetworkedJsonModel ("/products",{
                                                                       Column{"id","ID"} ,
                                                                       Column{"thumb","Image",QString(),"image"} ,
                                                                       Column{"name","Name"} ,
                                                                       Column{"sku","SKU"} ,
                                                                       Column{"description","description"} ,

                                                                       Column{"parent_id","Parent"} ,
                                                                       Column{"name_en","name_en"} ,
                                                                       Column{"name_ar","name_ar"} ,
                                                                       Column{"color","color"} ,
                                                                       Column{"color_en","color_en"} ,
                                                                       Column{"color_ar","color_ar"} ,
                                                                       Column{"goods_id","goods_id"} ,
                                                                       Column{"external_id","external_id"} ,

                                                                       Column{"external_sku","e_SKU"} ,
                                                                       Column{"size","Size"} ,

//                                                                       Column{"barcode","Barcode"} ,
                                                                       //Column{"cost","Cost",QString(), "currency"} ,
//                                                                       Column{"current_cost","Current Cost",QString(), "currency"} ,
                                                                       Column{"qty","Stock","products_stocks"} ,
                                                                       Column{"list_price","List Price", QString()}},parent)
{
    //requestData();
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
    PosNetworkManager::instance()->post("/products/update",params)->subcribe(this,&ProductsModel::onUpdateProductReply);

}




void ProductsModel::updateProduct(const QJsonObject &product)
{
    PosNetworkManager::instance()->post("/products/update",product)->subcribe(this,&ProductsModel::onUpdateProductReply);
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
    PosNetworkManager::instance()->post("/products/updateQuantity",params)->subcribe(this,&ProductsModel::onUpdateProductQuantityReply);
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

    PosNetworkManager::instance()->post("/products/purchaseProduct",params)->subcribe(this,&ProductsModel::onPurchaseStockReply);

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

    PosNetworkManager::instance()->post("/products/add",params)->subcribe([this](NetworkResponse *res){
        emit productAddReply(res->json().toObject());
    });
}

void ProductsModel::removeProduct(const int &productId)
{
    PosNetworkManager::instance()->post("/products/remove",QJsonObject{{"id",productId}})
            ->subcribe([this](NetworkResponse *res){
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
            QString value=PosNetworkManager::rawData(variant);
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
    QStringList wanted{"thumb","size","sku","external_sku","color","color_ar","color_en","goods_id","external_id","name_en","name_ar"};
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        QJsonArray attributes=product["attributes"].toArray();

        for(int j=0; j<attributes.size(); j++){
            QJsonObject attribute=attributes.at(j).toObject();
            QString attributeId=attribute["attribute_id"].toString();
            if(wanted.contains(attributeId)){
                product[attributeId]=attribute["value"];
            }
        }
        data.replace(i,product);
    }
    return data;
}
