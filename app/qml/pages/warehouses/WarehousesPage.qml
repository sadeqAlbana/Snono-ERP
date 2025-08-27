import QtQuick
import QtQuick.Controls.Basic
import PosFe

CrudViewPage {
    id: page
    title: qsTr("Warehouses")
    delegate: AppDelegateChooser {}
    model: StockLocationModel{}
    basePath: "qrc:/PosFe/qml/pages/warehouses";
    formFile: "WareHouseForm.qml"
    addPermission: "prm_add_warehouses"
    editPermission: "prm_edit_warehouses"
    deletePermission: "prm_remove_warehouses"
    deletePath: "warehouse"
}
