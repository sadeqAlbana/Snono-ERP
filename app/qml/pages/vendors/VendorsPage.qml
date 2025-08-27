import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Vendors")
    delegate: AppDelegateChooser {}
    model: VendorsModel{}
    basePath: "qrc:/PosFe/qml/pages/vendors";
    formFile: "VendorForm.qml"
    addPermission: "prm_add_vendors"
    editPermission: "prm_edit_vendors"
    deletePermission: "prm_remove_vendors"
    deletePath: "vendor"
}
