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
              case "cancelled": return qsTr("Cancelled");
              case "completed": return qsTr("Completed");
              case "pending": return qsTr("Pending");
              case "picked": return qsTr("Picked");
              case "delivered": return qsTr("Delivered");
              case "returned": return qsTr("returned");
              case "partially_returned": return qsTr("Partial");
              case "partially_fulfilled": return qsTr("Partial Return");
              case "processing": return qsTr("Processing");

              default: return "Invalid";
              }
        state: switch(model.display){
               case "cancelled": return "danger";
               case "completed": return "success";
               case "pending": return "info";
               case "picked": return "primary";
               case "delivered": return "success";
               case "returned": return "danger";
               case "partially_returned": return "warning";
               case "partially_fulfilled": return "warning";
               case "processing": return "primary";
               default: return "Invalid";
               }
    }
}
