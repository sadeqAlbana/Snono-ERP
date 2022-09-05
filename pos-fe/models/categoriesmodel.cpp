#include "categoriesmodel.h"
#include "posnetworkmanager.h"


CategoriesModel::CategoriesModel(QObject *parent) : AppNetworkedJsonModel("/categories",{
                                                                          Column{"id",tr("ID")},
                                                                          Column{"name",tr("Name")},
                                                                          Column{"parent_id",tr("Parent")}},
                                                                          parent)
{
    requestData();

    QList<int> test{1,2,3};

    QList<QJsonObject>{QJsonObject()};

    QStringList{"test","test"};
}


QVariant CategoriesModel::data(const QModelIndex &index, int role) const
{
    if(!index.isValid() || (index.row()>=rowCount() || index.column()>=columnCount())){
        return QVariant();
    }

     if(role==Qt::DisplayRole && index.column()==indexOf("name")){
         int pIdColumn=indexOf("parent_id");
         int pId=data(this->index(index.row(),pIdColumn),Qt::EditRole).toInt();
         if(pId==0){
             return AppNetworkedJsonModel::data(index,role);
         }else{
             QString title= AppNetworkedJsonModel::data(index,Qt::EditRole).toString();
             while(pId!=0){
                 QModelIndexList matches=match(this->index(0,indexOf("id")),Qt::EditRole,pId,1,Qt::MatchExactly);
                 if(!matches.size())
                     break;
                 QModelIndex parent=matches.value(0);
                 title.prepend(QString("%1 / ").arg(parent.siblingAtColumn(indexOf("name")).data(Qt::EditRole).toString()));
                 pId=parent.siblingAtColumn(pIdColumn).data(Qt::EditRole).toInt();
                 if(pId==0)
                     break;
             }
             return title;
         }
     }

     if(role==AppNetworkedJsonModel::roleNames().size()){
         return data(index.siblingAtColumn(indexOf("name")));
     }

     return AppNetworkedJsonModel::data(index,role);
}

QHash<int, QByteArray> CategoriesModel::roleNames() const
{
    QHash<int, QByteArray> roles=AppNetworkedJsonModel::roleNames() ;
    roles.insert(roles.size(),"category");
    return roles;
}


