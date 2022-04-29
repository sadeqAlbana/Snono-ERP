import QtQuick;import QtQuick.Controls.Basic;
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
