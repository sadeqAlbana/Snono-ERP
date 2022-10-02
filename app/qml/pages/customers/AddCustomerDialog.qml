import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import PosFe
AppDialog{
    id: dialog
    signal addedCustomer();
    width: parent.width*0.6
    height: parent.height*0.8
    Card{
        id: card
        title: qsTr("Add Customer")
        anchors.fill: parent;
        function addCustomer(){
            var name=nameTF.input.text;
            var firstName=firstNameTF.input.text;
            var lastName=lastNameTF.input.text;
            var email=emailTF.input.text;
            var address=addressTF.input.text;
            var phone=phoneTF.input.text;
            mdl.addCustomer(name,firstName,lastName,email,phone,address);
        }
        ColumnLayout{
            anchors.margins: 10
            anchors.fill: parent;
            spacing: 10
            CTextFieldGroup{id: nameTF; label.text: "Name"}
            CTextFieldGroup{id: firstNameTF; label.text: "First Name"}
            CTextFieldGroup{id: lastNameTF; label.text: "Last Name"}
            CTextFieldGroup{id: emailTF; label.text: "Email"}
            CTextFieldGroup{id: addressTF; label.text: "Address"}
            CTextFieldGroup{id: phoneTF; label.text: "Phone"}

            CustomersModel{
                id: mdl;
                Component.onCompleted: {
                    requestData();
                }
                onAddCustomerReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        addedCustomer();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end
            }
        }//model

          footer: AppDialogFooter{
               onCancel: dialog.close();
               onAccept: card.addCustomer();
          }
    } //card End
}
