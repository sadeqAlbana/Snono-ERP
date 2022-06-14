#include "appnetworkedjsonmodel.h"
#include "posnetworkmanager.h"
#include <QJsonDocument>
#include <QFile>
AppNetworkedJsonModel::AppNetworkedJsonModel(QString Url, const ColumnList &columns, QObject *parent) :
    NetworkedJsonModel(Url,columns,parent)
{
}

AppNetworkedJsonModel::AppNetworkedJsonModel(const ColumnList &columns, QObject *parent) : NetworkedJsonModel(columns,parent)
{

}


void AppNetworkedJsonModel::requestData()
{
    _busy=true;
    QJsonObject params{{"page",currentPage()+1},
                       {"count",100},
                       {"sortBy","id"},
                       {"direction","desc"},
                       {"search",_query}, //depricated
                       {"filter",m_filter}
                     };

    PosNetworkManager::instance()->post(url(),params)->subcribe(this,&AppNetworkedJsonModel::onTableRecieved);
}

void AppNetworkedJsonModel::setSearchQuery(const QString _query)
{
    this->_query=_query;
}

void AppNetworkedJsonModel::search()
{
    m_currentPage=0;
    _lastPage=-1;
    qDebug()<<"search: " << _query;
    requestData();
}

void AppNetworkedJsonModel::setFilter(const QJsonObject &filter)
{
    m_filter=filter;
    emit filterChanged(filter);
}

QJsonObject AppNetworkedJsonModel::filter() const
{
    return m_filter;
}


void AppNetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{
    qDebug()<<"current_page: " <<reply->json("current_page").toInt();
    qDebug()<<"last_page: " <<reply->json("last_page").toInt();

    if(reply->json("current_page").toInt()){
        setCurrentPage(reply->json("current_page").toInt());
        _lastPage=reply->json("last_page").toInt();
        m_hasPagination=true;
    }

    QJsonArray data=filterData(reply->json("data").toArray());
    qDebug()<<"data size: " << reply->json("data").toArray().size();
    if(m_currentPage<=1){
        setupData(data);
    }
    else{
        appendData(data);
    }


    emit dataRecevied();
    _busy=false;
}




