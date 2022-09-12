#include "barqlocationsmodel.h"

BarqLocationsModel::BarqLocationsModel(QObject *parent)
    : AppNetworkedJsonModel{"/barq/locations",{{"id",tr("ID")},{"name",tr("Name")}},parent}
{

}
