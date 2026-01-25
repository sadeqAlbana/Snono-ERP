import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Owners")
    delegate: AppDelegateChooser {}
    model: OwnersModel{}
    basePath: "qrc:/PosFe/qml/pages/equity";
    formFile: "OwnerForm.qml"
    addPermission: "prm_add_owner"
    editPermission: "prm_edit_owner"
    deletePermission: "prm_remove_owner"
    deletePath: "owner"
}
