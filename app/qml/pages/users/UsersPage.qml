import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
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
