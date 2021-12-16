import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import app.models 1.0
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Card{
    title: qsTr("Receipt")


     Rectangle{
        id: receipt
        property string date: "2021-12-15"
        property string customer: "Sadeq"
        property string phone : "07723815562"
        property string address: "Baghdad, Khadraa"
        property string reference: "234123123";
        property int fontSize: 20
        color: "white"
        border.color: "black"
        anchors.fill: parent;
        anchors.margins: 10

        ColumnLayout{
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: logo.left
            anchors.leftMargin: 20
            anchors.topMargin: 30

            Text {
                id: referenceTxt
                text: "Reference: " + receipt.reference
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }

            Text {
                id: dateTxt
                text: "Date: " + receipt.date
                font.pixelSize: receipt.fontSize;
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
            }
            spacing: 10

            Text {
                id: customerTxt
                text: "Customer: " + receipt.customer
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }

            Text {
                id: phoneTxt
                text: "Phone: " + receipt.phone
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }
            Text {
                id: addressTxt
                text: "Address: " + receipt.address
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }
        }


        Image{
            id: logo;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top
            anchors.topMargin: 20
            source: "file:///home/sadeq/Downloads/SheinIQ.png"
            width: 300
            fillMode: Image.PreserveAspectFit
        }

        CTableView{
            id: items;

            anchors.top: logo.bottom
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 30
            anchors.rightMargin: 30

            model: ReceiptModel{

            }

        }

    }


}
