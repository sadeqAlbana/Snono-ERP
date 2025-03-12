import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
CTableViewDelegate {
    padding: 12
    leftPadding: (width/6)
    rightPadding: leftPadding
    property var order;
    implicitWidth: 150

    contentItem: Badge{

        text: switch(model.display){
              case "pending": return qsTr("Pending");
              case "confirmed": return qsTr("Confirmed");
              case "cancelled": return qsTr("Cancelled");
              default: return "Invalid";
              }
        state: switch(model.display){
               case "pending": return "info";
               case "processing": return "primary";
               case "confirmed": return "success";
               case "cancelled": return "danger";
               default: return "Invalid";
               }
    }
}
