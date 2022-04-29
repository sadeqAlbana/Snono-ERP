import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

AppDialog {
    id: dialog
    property real amount;
    property real paid;
    property real tendered;
    signal accepted(var paid, var tendered);

    onPaidChanged: {
        tendered=paid-amount;
    }
    width: parent.width*0.4
    height: parent.height*0.5

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
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                implicitWidth: 80

                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Pay")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                implicitWidth: 80

                onClicked: dialog.accepted(paid,tendered);
            }
        } //footer end

    } //card end


}
