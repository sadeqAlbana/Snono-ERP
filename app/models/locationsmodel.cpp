#include "locationsmodel.h"


LocationsModel::LocationsModel(QObject *parent) : AppNetworkedJsonModel ("/locations",{
                                           {"id",tr("ID")} ,
                                           {"name",tr("Name")} ,
                                           {"first_name",tr("First Name")} ,

                                           {"country",tr("Country")} ,
                                           {"province",tr("Province")} ,
                                           {"city",tr("City")} ,
                                           {"district",tr("District")} ,
                                           {"postcode",tr("PostCode")} ,
                                           {"building",tr("Building")} ,
                                           {"floor",tr("Floor")} ,
                                           {"apartment",tr("Apartment")} ,
                                           {"phone",tr("Phone")},
                                           {"details",tr("Details")}

                                          } ,parent)
{
}
