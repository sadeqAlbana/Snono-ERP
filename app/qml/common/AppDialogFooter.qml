import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic

import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

RowLayout{
    signal accept();
    signal cancel();
    property string acceptText : qsTr("Accept")
    property string cancelText : qsTr("Cancel")
    HorizontalSpacer{}
    CButton{
        text: qsTr(cancelText)
        palette.button: "#e55353"
        palette.buttonText: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: cancel();
    }
    CButton{
        text: qsTr(acceptText)
        palette.button: "#2eb85c"
        palette.buttonText: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: accept();
    }
} //footer end
