#include "appnetworkedjsonmodel.h"
#include "../posnetworkmanager.h"
#include <QJsonDocument>
#include <QFile>
#include <networkresponse.h>


AppNetworkedJsonModel::AppNetworkedJsonModel(QObject *parent) : NetworkedJsonModel(QString(),JsonModelColumnList(),parent)
{

}

AppNetworkedJsonModel::AppNetworkedJsonModel(QString Url, const JsonModelColumnList &columns, QObject *parent, bool usePagination) :
    NetworkedJsonModel(Url,columns,parent),m_direction("desc"),m_usePagination(usePagination)
{

}

AppNetworkedJsonModel::AppNetworkedJsonModel(const JsonModelColumnList &columns, QObject *parent) : NetworkedJsonModel(columns,parent)
{

}



void AppNetworkedJsonModel::requestData()
{
    m_busy=true;

    if(m_oldFilter!=m_filter){
        m_oldFilter=m_filter;
        if(m_usePagination){
            m_currentPage=0;
            m_lastPage=-1;
        }
    }

    QJsonObject params;
    params["filter"]=m_filter;
    if(m_usePagination){
        params["page"]=currentPage()+1;
        params["count"]=100;
    }
    params["sortBy"]=sortKey();
    params["direction"]=direction();
    params["search"]=_query;


    PosNetworkManager::instance()->post(QUrl(url()),params)->subscribe(this,&AppNetworkedJsonModel::onTableRecieved);
}

void AppNetworkedJsonModel::setSearchQuery(const QString _query)
{
    this->_query=_query;
}

QVariant AppNetworkedJsonModel::data(const QModelIndex &index, int role) const
{

    if(!(index.isValid() && index.column()<columnCount() && index.row()<rowCount())){
        return QVariant();
    }

    JsonModelColumn column=m_columns.value(index.column());


    if(column.m_type=="link" && role==AppItemDataRole::LinkRole){
        QUrl link=column.m_metadata["link"].toUrl();
        return link;
    }
    if(column.m_type=="link" && role==AppItemDataRole::LinkKeyRole){
        QString key=column.m_metadata["linkKey"].toString();
        return key;
    }

    if(column.m_type=="link" && role==AppItemDataRole::LinkKeyDataRole){
        QString key=column.m_metadata["linkKey"].toString();

        return m_records.at(index.row())[key];
    }

    return NetworkedJsonModel::data(index,role);

}

void AppNetworkedJsonModel::search()
{
    if(m_usePagination){
        m_currentPage=0;
        m_lastPage=-1;
    }
    requestData();
}

void AppNetworkedJsonModel::setFilter(const QJsonObject &filter)
{
    m_filter=filter;
    emit filterChanged(filter);
}

const QString &AppNetworkedJsonModel::direction() const
{
    return m_direction;
}

void AppNetworkedJsonModel::setDirection(const QString &newDirection)
{
    if (m_direction == newDirection)
        return;
    m_direction = newDirection;
    emit directionChanged();
}

void AppNetworkedJsonModel::classBegin()
{

}

void AppNetworkedJsonModel::componentComplete()
{
//    qDebug()<<"parent object: " << QObject::parent();
    requestData();
}

QHash<int, QByteArray> AppNetworkedJsonModel::roleNames() const
{
    auto names=NetworkedJsonModel::roleNames();
    names.insert(AppItemDataRole::LinkRole,"__link");
    names.insert(AppItemDataRole::LinkKeyRole,"__linkKey");
    names.insert(AppItemDataRole::LinkKeyDataRole,"__linkKeyData");

    return names;
}

const QString &AppNetworkedJsonModel::sortKey() const
{
    return m_sortKey;
}

void AppNetworkedJsonModel::setSortKey(const QString &newSortKey)
{
    if (m_sortKey == newSortKey)
        return;
    m_sortKey = newSortKey;
    emit sortKeyChanged();
}

bool AppNetworkedJsonModel::usePagination() const
{
    return m_usePagination;
}

void AppNetworkedJsonModel::setUsePagination(bool newUsePagination)
{
    if (m_usePagination == newUsePagination)
        return;
    m_usePagination = newUsePagination;

    emit usePaginationChanged();
}



QJsonObject AppNetworkedJsonModel::filter() const
{
    return m_filter;
}


void AppNetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{

    if(m_usePagination){
        if(reply->json("current_page").toInt()){
            setCurrentPage(reply->json("current_page").toInt());
            m_lastPage=reply->json("last_page").toInt();
            m_hasPagination=true;
        }
    }

//    QObject *pr=QObject::parent();;
//    qDebug()<<"parent: " << pr;
    QJsonArray data=filterData(reply->json("data").toArray());
//    qDebug()<<"data size: " << reply->json("data").toArray().size();
    if(m_usePagination){
        if(m_currentPage<=1){
            setRecords(data);
        }
        else{
            appendData(data);
        }
    }else{
        setRecords(data);
    }


    emit dataRecevied();
    m_busy=false;
}




