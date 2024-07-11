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
    activateCanFetchMoreLimiter();
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

QJsonObject AppNetworkedJsonModel::defaultRecord() const
{
    return m_defaultRecord;
}

void AppNetworkedJsonModel::setDefaultRecord(const QJsonObject &newDefaultRecord)
{
    if (m_defaultRecord == newDefaultRecord)
        return;
    m_defaultRecord = newDefaultRecord;
    emit defaultRecordChanged();
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
    if(!m_url.isEmpty()){
        requestData();
    }

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

    if(!m_defaultRecord.isEmpty()){
        QJsonObject record=data.at(0).toObject();
        for(auto key : record.keys()){
            record[key]=QJsonValue();
        }
        for(auto key : m_defaultRecord.keys()){
            record[key]=m_defaultRecord[key];
        }

        data.prepend(record);
    }
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




