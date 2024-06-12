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
    implicitWidth: 350
    contentItem: Badge{

        text: switch(model.display){
              case "manifest_created": return qsTr("Manifest Created");
              case "in_transit": return qsTr("In Transit");
              default: return model.display;
              }
        state: switch(model.display){
               case "manifest_created": return "Invalid";
               case "in_transit": return "success";
               default: return "Invalid";
               }
    }
}
