import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils

CTableViewDelegate {
    id: control
     property url link;
     property var linkData;


    MouseArea{
        anchors.fill: parent
        onClicked: {
            console.log(model.edit);
            Router.navigate(model.__link,{
                                                   "keyName": model.__linkKey,
                                                   "keyValue":model[model.__linkKey]});
        }

    }

    contentItem: Text{
        text: display
        color: control.palette.inactive.link
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
