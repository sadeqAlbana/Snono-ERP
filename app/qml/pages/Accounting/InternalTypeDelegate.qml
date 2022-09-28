import QtQuick;
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
              case "asset": return qsTr("Asset");
              case "liability": return qsTr("Liability");
              case "income": return qsTr("Income");
              case "expense": return qsTr("Expense");
              case "equity": return qsTr("Equity");

              default: return "Invalid";
              }
        state: switch(model.display){
               case "asset": return "success";
               case "liability": return "danger";
               case "income": return "info";
               case "expense": return "warning";
               case "equity": return "secondary";

               default: return "Invalid";
               }
    }
}
