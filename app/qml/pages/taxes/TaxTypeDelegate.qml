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
