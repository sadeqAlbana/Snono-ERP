#include "productsdemomodel.h"
#include <networkresponse.h>

ProductsDemoModel::ProductsDemoModel(QObject *parent) : AppNetworkedJsonModel ("/products/demo",
                            JsonModelColumnList(),parent)
{
    //requestData();

    JsonModelColumnList list{
                             {"id",tr("ID")} ,
                             {"name",tr("Name")} ,
                             {"sizes_stocks","sizes stocks"},
                             {"list_price",tr("List Price"),QString(),false,"currency"}};

    m_columns=list;
}

QJsonArray ProductsDemoModel::filterData(QJsonArray data)
{
    QStringList wanted;

    for(const QJsonValue &value: m_wantedColumns){
        wanted << value["id"].toString();
    }
    for(int i=0; i<data.size(); i++){
        QJsonObject product=data.at(i).toObject();
        QJsonArray attributes=product["attributes"].toArray();
        QJsonArray sizesMap;
        QJsonArray children=product["children"].toArray();
        for(QJsonValue childValue: children){
            QJsonObject child=childValue.toObject();

            QJsonArray childAttributes=child["attributes"].toArray();

            for(int j=0; j<childAttributes.size(); j++){
                QJsonObject attribute=childAttributes.at(j).toObject();
                QString attributeId=attribute["attribute_id"].toString();
                if(attributeId=="size"){
                    sizesMap.append(QJsonObject{{"size",attribute["value"].toString()},{"qty",
                                                 child["products_stocks"].toObject()["qty"].toInt()}});
                }
            }
        }

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
        product["sizes_stocks"]=sizesMap;


        data.replace(i,product);
    }
    return data;
}

void ProductsDemoModel::onTableRecieved(NetworkResponse *reply)
{
    qDebug()<<"Table received";
    if(m_wantedColumns.isEmpty()){
        this->m_wantedColumns=reply->json("attributes").toArray();
        for(const QJsonValue &value: m_wantedColumns){
            m_columns.append(JsonModelColumn{value["id"].toString(),value["name"].toString(),QString(),false,value["type"].toString()});
        }
    }
    AppNetworkedJsonModel::onTableRecieved(reply);
}
