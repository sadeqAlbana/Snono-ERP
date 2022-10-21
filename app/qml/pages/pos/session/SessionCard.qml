import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils


Card{
    id: rect;
    implicitWidth: 400
    implicitHeight: 250
    signal close();
    signal resume();
    clip: true

    title: "POS/0001"

    property int ordersCount
    property string totalAmount
    property var session;

    GridLayout{
        anchors.fill: parent;
        columns:2

        CLabel{
            text: qsTr("Total Orders")
            font.bold: true
            Layout.leftMargin: 25
        }
        CLabel{
            text: ordersCount
            font.bold: true
        }

        CLabel{
            text: qsTr("Total Amount")
            font.bold: true
            Layout.leftMargin: 25
        }

        CLabel{
            text: Utils.formatCurrency(totalAmount)
            font.bold: true
        }

    }

    footer: RowLayout{
        CButton{
            text: qsTr("Resume")
            palette.button: "#2eb85c"
            palette.buttonText: "#ffffff"
            //Layout.minimumWidth: implicitWidth
            implicitHeight: 45
            Layout.leftMargin: 25
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            onClicked: resume();
        }

        CButton{
            text: qsTr("Close")
            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            implicitHeight: 45

            Layout.topMargin: 10
            Layout.bottomMargin: 10
            onClicked: close();

        }
        Rectangle{color: "transparent"; Layout.fillWidth: true}

    } //footer end

}
