import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay

    property real amount;
    signal accepted(var amount);
    onAccepted: dialog.close();
    width: parent.width*0.2
    height: parent.height*0.3
    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Card{
        title: qsTr("Deposit Money")
        anchors.fill: parent;
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10



            CTextFieldGroup{
                id: amountTF
                label.text: qsTr("Amount");
                Layout.fillWidth: true;
                input.text: amount
                input.validator: DoubleValidator{bottom: 0;top:1000000000; notation: DoubleValidator.StandardNotation}
                //input.displayText: Utils.formatCurrency(input.text)
                //input.inputMask: "9"
                Binding{
                    target: dialog
                    property: "amount"
                    value: amountTF.input.text
                }

            }

        }

        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Cancel")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 45
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Deposit")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 45
                Layout.margins: 10
                onClicked: dialog.accepted(amount);
            }
        } //footer end

    } //card end


}
