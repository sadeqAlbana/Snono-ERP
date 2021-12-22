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
    property var order;
    contentItem: Badge{

        text: switch(model.display){
              case "pending": return qsTr("Pending");
              case "processing": return qsTr("Processing");
              case "delivered": return qsTr("Delivered");
              case "canceled": return qsTr("Canceled");
              default: return "Invalid";
              }
        state: switch(model.display){
               case "pending": return "warning";
               case "processing": return "primary";
               case "delivered": return "success";
               case "canceled": return "danger";

               default: return "Invalid";
               }
    }
}
