#include "shipmentsmodel.h"


ShipmentsModel::ShipmentsModel(QObject *parent)
    : AppNetworkedJsonModel{"/shipments",
                            {{"id",tr("ID")},
                            {"name",tr("Carrier"),"carrier"},
                            {"username",tr("Driver"),"driver.user"},

                            {"status",tr("Status")},
                            {"notes",tr("Notes")}

                            },


                            parent}
{
}

