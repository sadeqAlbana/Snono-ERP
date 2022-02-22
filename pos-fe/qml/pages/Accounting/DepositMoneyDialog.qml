import QtQuick 2.15
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
AppDialog {
    id: dialog
    property real amount;
    signal accepted(var amount);
    onAccepted: dialog.close();
    width: parent.width*0.2
    height: parent.height*0.3

    Card{
        title: qsTr("Deposit Money")
        anchors.fill: parent;
        padding: 10
        ColumnLayout{
            anchors.fill: parent;
            CTextFieldGroup{
                id: amountTF
                label.text: qsTr("Amount");
                input.text: amount
                input.validator: DoubleValidator{bottom: 0; top:1000000000; notation: DoubleValidator.StandardNotation}
                //input.displayText: Utils.formatCurrency(input.text)
                //input.inputMask: "9"
                Binding{
                    target: dialog
                    property: "amount"
                    value: amountTF.input.text
                }//binding
            }//tf
        }//ColumnLayout
        footer: AppDialogFooter{
            onAccept: dialog.accepted(amount);
            onCancel: dialog.close();
        }//footer
    } //card end
}//Popup
