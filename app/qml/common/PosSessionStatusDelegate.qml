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
    property var order;
    implicitWidth: 150

//    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
//                            implicitContentWidth + leftPadding + rightPadding)
    contentItem: Badge{
        text: switch(model.display){
              case 1: return qsTr("Opened");
              case 0: return qsTr("Closed");
              default: return "Invalid";
              }
        state: switch(model.display){
               case 1: return "success";
               case 0: return "danger";
               default: return "Invalid";
               }
    }
}
