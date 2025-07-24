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
              case "pos": return qsTr("POS");
              case "online": return qsTr("Online");
              default: return "Invalid";
              }
        state: switch(model.display){
               case "pos": return "primary";
               case "online": return "primary";
               default: return "Invalid";
               }
    }
}
