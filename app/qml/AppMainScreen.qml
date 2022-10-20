import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQml.Models
import CoreUI.Notifications
import CoreUI
import CoreUI.Base
import CoreUI.Impl
import CoreUI.Menus
import QtQuick.Controls.impl as Impl
import "qrc:/PosFe/qml/nav.js" as NavJSS;

MainScreen{
    navBar: NavJSS.navBar();
    permissionProvider: AuthManager.hasPermission
}
