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
              case "unpaid": return qsTr("Unpaid");
              case "partially_paid": return qsTr("Partially Paid");
              case "paid": return qsTr("Paid");
              default: return "Invalid";
              }
        state: switch(model.display){
               case "unpaid": return "danger";
               case "partially_paid": return "primary";
               case "paid": return "success";
               default: return "Invalid";
               }
    }
}
