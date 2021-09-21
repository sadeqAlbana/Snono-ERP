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
