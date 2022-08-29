#include "appnetworkedjsonmodel.h"
#include "posnetworkmanager.h"
#include <QJsonDocument>
#include <QFile>
AppNetworkedJsonModel::AppNetworkedJsonModel(QString Url, const ColumnList &columns, QObject *parent, bool usePagination) :
    NetworkedJsonModel(Url,columns,parent),m_direction("desc"),m_usePagination(usePagination)
{

}

AppNetworkedJsonModel::AppNetworkedJsonModel(const ColumnList &columns, QObject *parent) : NetworkedJsonModel(columns,parent)
{

}


void AppNetworkedJsonModel::requestData()
{
    _busy=true;

    if(m_oldFilter!=m_filter){
        m_oldFilter=m_filter;
        if(m_usePagination){
            m_currentPage=0;
            _lastPage=-1;
        }
    }

    QJsonObject params;
    params["filter"]=m_filter;
    if(m_usePagination){
        params["page"]=currentPage()+1;
        params["count"]=100;
    }
    params["sortBy"]="id";
    params["direction"]=m_direction;
    params["search"]=_query;


    PosNetworkManager::instance()->post(url(),params)->subcribe(this,&AppNetworkedJsonModel::onTableRecieved);
}

void AppNetworkedJsonModel::setSearchQuery(const QString _query)
{
    this->_query=_query;
}

void AppNetworkedJsonModel::search()
{
    if(m_usePagination){
        m_currentPage=0;
        _lastPage=-1;
    }
    requestData();
}

void AppNetworkedJsonModel::setFilter(const QJsonObject &filter)
{
    m_filter=filter;
    emit filterChanged(filter);
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

const QString &AppNetworkedJsonModel::direction() const
{
    return m_direction;
}

void AppNetworkedJsonModel::setDirection(const QString &newDirection)
{
    m_direction = newDirection;
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
            _lastPage=reply->json("last_page").toInt();
            m_hasPagination=true;
        }
    }

    QJsonArray data=filterData(reply->json("data").toArray());
//    qDebug()<<"data size: " << reply->json("data").toArray().size();
    if(m_usePagination){
        if(m_currentPage<=1){
            setupData(data);
        }
        else{
            appendData(data);
        }
    }else{
        setupData(data);
    }


    emit dataRecevied();
    _busy=false;
}




