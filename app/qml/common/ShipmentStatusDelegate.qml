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
              case "out_for_delivery": return qsTr("Out for Delivery");
              case "deliviered": return qsTr("Deliviered");
              default: return model.display;
              }
        state: switch(model.display){
               case "manifest_created": return "info";
               case "in_transit": return "secondary";
               case "out_for_delivery": return "primary";
               case "deliviered": return "success";

               default: return "Invalid";
               }
    }
}
