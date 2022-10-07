import QtQuick;

import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
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
