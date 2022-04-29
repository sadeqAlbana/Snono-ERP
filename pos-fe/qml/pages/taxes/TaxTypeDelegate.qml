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
    implicitWidth: 150
    //Component.onCompleted: console.log(model.display)
    contentItem: Badge{

        text: switch(model.display){
              case "1": return qsTr("Percentage");
              case "2": return qsTr("Fixed");


              default: return "Invalid";
              }
        state: switch(model.display){
               case "1": return "success";
               case "2": return "info";

               default: return "Invalid";
               }
    }
}
