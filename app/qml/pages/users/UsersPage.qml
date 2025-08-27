import QtQuick
import QtQuick.Controls.Basic
import PosFe

CrudViewPage {
    id: page
    title: qsTr("Users")
    delegate: AppDelegateChooser {}
    model: UsersModel{}
    basePath: "qrc:/PosFe/qml/pages/users";
    formFile: "UsersForm.qml"
    addPermission: "prm_add_users"
    editPermission: "prm_edit_users"
    deletePermission: "prm_remove_users"
    deletePath: "user"
}
