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
    implicitWidth: 150
    contentItem: Badge{

        text: switch(model.display){
              case "processing": return qsTr("Processing");
              case "done": return qsTr("Done");
              case "failed": return qsTr("Failed");

              default: return "Invalid";
              }
        state: switch(model.display){
               case "processing": return "info";
               case "done": return "success";
               case "failed": return "danger";
               default: return "Invalid";
               }
    }
}
