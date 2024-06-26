import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
CTableViewDelegate {
    text: (model.display===undefined || model.display===null || model.display==="") ? "" : Qt.formatDateTime(model.display,"yyyy-MM-dd hh:mm:ss ap")
}
