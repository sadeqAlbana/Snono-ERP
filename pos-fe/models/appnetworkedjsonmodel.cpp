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
    QJsonObject params{{"page",m_currentPage+1},
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
    if(reply->json("current_page").toInt()){
        setCurrentPage(reply->json("current_page").toInt());
        m_hasPagination=true;

    }
    //_lastPage=reply->json("last_page").toInt();

    QJsonArray data=filterData(reply->json("data").toArray());

    if(m_currentPage<=1){
        setupData(data);
    }
    else{
        appendData(data);
    }

    if(data.isEmpty())
        _lastPage=-2;
    emit dataRecevied();
    _busy=false;
}


bool AppNetworkedJsonModel::canFetchMore(const QModelIndex &parent) const
{
    Q_UNUSED(parent);
    if(!m_hasPagination)
        return false;

    return  (_lastPage!=-2 && !_busy);
}

void AppNetworkedJsonModel::fetchMore(const QModelIndex &parent)
{
    Q_UNUSED(parent);
    requestData();
}

