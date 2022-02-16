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
    property real paid;
    property real tendered;
    signal accepted(var paid, var tendered);

    onPaidChanged: {
        tendered=paid-amount;
    }

    //    margins: 0
    //    padding: 0
    //    closePolicy: Popup.NoAutoClose
    width: parent.width*0.4
    height: parent.height*0.5
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
        title: qsTr("Pay")
        anchors.fill: parent;
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10



            CTextFieldGroup{
                id: amountTF
                label.text: qsTr("Amount");
                Layout.fillWidth: true;
                input.text: amount
                input.readOnly: true
                input.validator: DoubleValidator{bottom: 0;top:1000000000}
                Binding{
                    target: dialog
                    property: "amount"
                    value: amountTF.input.text
                }

            }


            CTextFieldGroup{
                id: paidTF
                label.text: qsTr("Paid");
                Layout.fillWidth: true;
                input.text: paid
                input.validator: DoubleValidator{bottom: paid;top:1000000000}
                Binding{
                    target: dialog
                    property: "paid"
                    value: paidTF.input.text
                }

            }

            CTextFieldGroup{
                id: tenderedTF
                label.text: qsTr("Tendered");
                Layout.fillWidth: true;
                input.text: tendered
                input.readOnly: true
                input.validator: DoubleValidator{bottom: 0;top:1000000000}
                Binding{
                    target: dialog
                    property: "tendered"
                    value: tenderedTF.input.text
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
                implicitHeight: 60
                Layout.margins: 10
                implicitWidth: 80

                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Pay")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                implicitWidth: 80

                onClicked: dialog.accepted(paid,tendered);
            }
        } //footer end

    } //card end


}
