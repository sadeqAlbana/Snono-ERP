#include "barqlocationsmodel.h"

BarqLocationsModel::BarqLocationsModel(QObject *parent)
    : AppNetworkedJsonModel{"/barq/locations",{{"id","ID"},{"name","Name"}},parent}
{

}
