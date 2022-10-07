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
              case "receivable": return qsTr("Receivable");
              case "payable": return qsTr("Payable");
              case "liquidity": return qsTr("Liquidity");
              case "other": return qsTr("Other");

              default: return "Invalid";
              }
        state: switch(model.display){
               case "receivable": return "success";
               case "payable": return "danger";
               case "liquidity": return "info";
               case "other": return "secondary";

               default: return "Invalid";
               }
    }
}
