#include "locationsmodel.h"


LocationsModel::LocationsModel(QObject *parent) : AppNetworkedJsonModel ("/locations",{
                                           {"id",tr("ID")} ,
                                           {"name",tr("Name")} ,
                                           {"country",tr("Country")} ,
                                           {"province",tr("Province")} ,
                                           {"city",tr("City")} ,
                                           {"district",tr("District")} ,
                                           {"postcode",tr("PostCode")} ,
                                           {"building",tr("Building")} ,
                                           {"floor",tr("Floor")} ,
                                           {"apartment",tr("Apartment")} ,
                                           {"phone",tr("Phone")},
                                           {"hints",tr("Hints")}

                                          } ,parent)
{
}
