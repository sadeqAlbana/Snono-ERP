import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

RowLayout{
    signal accept();
    signal cancel();
    property string acceptText : qsTr("Accept")
    property string cancelText : qsTr("Cancel")
    HorizontalSpacer{}
    CButton{
        text: cancelText
        palette.button: "#e55353"
        palette.buttonText: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: cancel();
    }
    CButton{
        text: acceptText
        palette.button: "#2eb85c"
        palette.buttonText: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: accept();
    }
} //footer end
