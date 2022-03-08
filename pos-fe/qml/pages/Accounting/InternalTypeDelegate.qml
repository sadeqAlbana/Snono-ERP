import QtQuick 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
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
