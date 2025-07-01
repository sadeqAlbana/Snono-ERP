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
            Router.navigate(model.__link,{          "readOnly" : true,
//                                                   "dataKey": model.__linkKey,
                                                   "keyValue":__linkKeyData});
        }

    }


    contentItem: Label {
        clip: false
        text: control.model.display ?? ""
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        color: control.palette.inactive.link
        visible: !control.editing
    }



    // contentItem: Text{
    //     text: control.display
    //     color: control.palette.inactive.link
    //     font.pixelSize: 18

    // }
}
