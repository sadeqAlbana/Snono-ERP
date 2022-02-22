import QtQuick 2.0
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
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
    property string acceptText : "Accept"
    property string cancelText : "Cancel"
    HorizontalSpacer{}
    CButton{
        text: qsTr(cancelText)
        color: "#e55353"
        textColor: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: cancel();
    }
    CButton{
        text: qsTr(acceptText)
        color: "#2eb85c"
        textColor: "#ffffff"
        implicitHeight: 45
        Layout.margins: 10
        onClicked: accept();
    }
} //footer end
