import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQml.Models
import CoreUI.Notifications
import CoreUI
import CoreUI.Base
import CoreUI.Impl
import CoreUI.Menus
import QtQuick.Controls.impl as Impl
import "qrc:/PosFe/qml/nav.js" as NavJSS

MainScreen {
    navBar: NavJSS.navBar()
    permissionProvider: function(permission){return AuthManager.hasPermission(permission);}
    icon: "qrc:/images/icons/SS_Logo_Color-cropped.svg"
    iconWidth: 177
    iconHeight: 43
    initialIndex: 18
}
