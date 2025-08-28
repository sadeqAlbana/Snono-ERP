import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Drivers")
    delegate: AppDelegateChooser {}
    model: DriversModel{}
    basePath: "qrc:/PosFe/qml/pages/delivery";
    formFile: "DriverForm.qml"
    addPermission: "prm_add_drivers"
    editPermission: "prm_edit_drivers"
    deletePermission: "prm_remove_drivers"
    deletePath: "driver"
}
