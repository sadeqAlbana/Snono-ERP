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
//https://stackoverflow.com/questions/17146747/capture-qml-drawing-buffer-without-displaying

Card{
    title: qsTr("Receipt")


    Rectangle{
        id: receipt

        height: img.height+leftLayout.implicitHeight+bottomLayout.implicitHeight+items.implicitHeight
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

        property var model : ReceiptModel{
            Component.onCompleted: requestData();
        }

        ColumnLayout{
            id: leftLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: img.left
            anchors.leftMargin: 20
            anchors.topMargin: 30

            spacing: 10

            Text {
                id: customerTxt
                text: "Customer: " + receipt.model.customer
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }

            Text {
                id: phoneTxt
                text: "Phone: " + receipt.model.phone
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }
            Text {
                id: addressTxt
                text: "Address: " + receipt.model.address
                font.pixelSize: receipt.fontSize;
                wrapMode: Text.WordWrap
            }
        }


        ColumnLayout{
            id: righLayout
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: img.right
            anchors.rightMargin: 20
            anchors.topMargin: 30

            Text {
                id: referenceTxt
                text: "Reference: " + receipt.model.reference
                font.pixelSize: receipt.fontSize;
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight
                wrapMode: Text.WordWrap
            }

            Text {
                id: dateTxt
                text: "Date: " + receipt.model.date
                font.pixelSize: receipt.fontSize;
                horizontalAlignment: Text.AlignRight
                Layout.alignment: Qt.AlignRight

                wrapMode: Text.WordWrap

            }


            spacing: 10

        }

        Image{
            id: img;
            anchors.horizontalCenter: parent.horizontalCenter;
            anchors.top: parent.top
            anchors.topMargin: 20
            property bool rounded: true
            property bool adapt: true
            source: "qrc:/images/icons/SheinIQ.png"
            width: 200
            fillMode: Image.PreserveAspectFit
            layer.enabled: rounded
            layer.effect: OpacityMask {
                maskSource: Item {
                    width: img.width
                    height: img.height
                    Rectangle {
                        anchors.centerIn: parent
                        width: img.adapt ? img.width : Math.min(img.width, img.height)
                        height: img.adapt ? img.height : width
                        radius: Math.min(width, height)
                    }
                }
            }

        }

        CTableView{
            id: items;

            anchors.top: img.bottom
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 20
            anchors.rightMargin: 20
            //anchors.bottom: parent.bottom
            height: implicitHeight
            anchors.bottomMargin: 200

            model: receipt.model;

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
            }

        }


        ColumnLayout{
            id: bottomLayout
            anchors.top: items.bottom
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.topMargin: 30

            Text {
                id: subtotalTxt
                text: "Tax: " + Utils.formatCurrency(receipt.model.taxAmount)
                font.pixelSize: receipt.fontSize;
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
            }

            Text {
                id: totalTxt
                text: "Total: " + Utils.formatCurrency(receipt.model.total)
                font.pixelSize: receipt.fontSize;
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
            }
            spacing: 10



        }

    } //receipt end


}
