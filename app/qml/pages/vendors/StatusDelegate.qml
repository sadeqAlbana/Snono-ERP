import QtQuick;import QtQuick.Controls.Basic;
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
              case 0: return qsTr("Unpaid");
              case 1: return qsTr("Paid");
              default: return "Invalid";
              }
        state: switch(model.display){
               case 0: return "danger";
               case 1: return "success";
               default: return "Invalid";
               }
    }
}
