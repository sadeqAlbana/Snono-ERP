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
    leftPadding: (width/3)
    rightPadding: leftPadding
    implicitWidth: 150
    contentItem: Badge{

        text: switch(model.display){
              case "posted": return qsTr("Posted");
              case "draft": return qsTr("Draft");
              case "cancelled": return qsTr("Cancelled");
              default: return "Invalid";
              }
        state: switch(model.display){
               case "posted": return "success";
               case "draft": return "secondary";
               case "cancelled": return "danger";
               default: return "Invalid";
               }
    }
}
