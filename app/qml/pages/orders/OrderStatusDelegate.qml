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
    property var order;
    implicitWidth: 150



//    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
//                            implicitContentWidth + leftPadding + rightPadding)
    contentItem: Badge{

        text: switch(model.display){
              case "pending": return qsTr("Pending");
              case "processing": return qsTr("Processing");
              case "delivered": return qsTr("Delivered");
              case "returned": return qsTr("returned");
              case "partially_returned": return qsTr("Partial");

              default: return "Invalid";
              }
        state: switch(model.display){
               case "pending": return "info";
               case "processing": return "primary";
               case "delivered": return "success";
               case "returned": return "danger";
               case "partially_returned": return "warning";


               default: return "Invalid";
               }
    }
}
