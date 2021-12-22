#include "appnetworkedjsonmodel.h"
#include "posnetworkmanager.h"
AppNetworkedJsonModel::AppNetworkedJsonModel(QString Url, const ColumnList &columns, QObject *parent) :
    NetworkedJsonModel(Url,columns,parent)
{
}


void AppNetworkedJsonModel::requestData()
{
    _busy=true;
    //qDebug()<<"current page: " <<_currentPage;
    QJsonObject params{{"page",++_currentPage},
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
    _currentPage=0;
    _lastPage=-1;
    qDebug()<<"search: " << _query;
    requestData();
}

void AppNetworkedJsonModel::setFilter(const QJsonObject &filter)
{
    m_filter=filter;
}

QJsonObject AppNetworkedJsonModel::filter() const
{
    return m_filter;
}


void AppNetworkedJsonModel::onTableRecieved(NetworkResponse *reply)
{
    //qDebug()<<reply->json();
    //qDebug()<<"page received : " << _currentPage;

    _currentPage=reply->json("current_page").toInt();
    _lastPage=reply->json("last_page").toInt();
    //qDebug()<<"last page: " << _lastPage;
    if(_currentPage<=1){
    setupData(reply->json("data").toArray());
    }
    else{
        appendData(reply->json("data").toArray());
    }

    emit dataRecevied();
    _busy=false;
}

