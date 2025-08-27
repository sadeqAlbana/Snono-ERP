import QtQuick
import QtQuick.Controls.Basic
import PosFe

CrudViewPage {
    id: page
    title: qsTr("ACL Groups")
    delegate: AppDelegateChooser {}
    model: AclGroupsModel{}
    basePath: "qrc:/PosFe/qml/pages/aclGroups";
    formFile: "AclGroupForm.qml"
    addPermission: "prm_add_acl_group"
    editPermission: "prm_edit_acl_group"
    deletePermission: "prm_remove_acl_group"
    deletePath: "aclGroup"
}
