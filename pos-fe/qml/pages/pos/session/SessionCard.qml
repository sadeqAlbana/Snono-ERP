import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/common"

Card{
    id: rect;
    implicitWidth: 400
    implicitHeight: 250

    title: "POS/0001"

    property int ordersCount
    property string totalAmount

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
            text: totalAmount
            font.bold: true
        }

    }

    footer: RowLayout{
        CButton{
            text: qsTr("Resume")
            color: "#2eb85c"
            textColor: "#ffffff"
            implicitHeight: 35
            Layout.leftMargin: 25
            Layout.topMargin: 10
            Layout.bottomMargin: 10        }

        CButton{
            text: qsTr("Close")
            color: "#e55353"
            textColor: "#ffffff"
            implicitHeight: 35
            Layout.topMargin: 10
            Layout.bottomMargin: 10

        }

        Rectangle{color: "transparent"; Layout.fillWidth: true}

    } //footer end

}
