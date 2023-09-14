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
     required property url link;
     property var linkData;

    MouseArea{
        anchors.fill: parent
        onClicked: Router.navigate(model._data_link,model._data_data);

    }

    contentItem: Text{
        text: display
        color: control.palette.inactive.link
        font.pixelSize: 18
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
}
