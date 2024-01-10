import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Buttons
import CoreUI.Palettes
CFormView {
    id: control
    padding: 10
    rowSpacing: 30

    header.visible: true
    url: "/driver"

    columns: 4



    CLabel{
        Layout.columnSpan: 4
        text: qsTr("if you select an existing user ID for the driver, only a name and a phone number will be required, otherwise you will need to fill the whole form and a new user will be created for the driver")
        font.italic: true
        color: "red"
    }

    CCheckBox{
        id: useExistingUser;
        objectName: "use_existing_user"
        text: qsTr("use an existing user")
    }

    CComboBox{
        objectName: "user_id"
        enabled: useExistingUser.checked
        model: AppNetworkedJsonModel{
            url: "/user/list"
        }

       valueRole: "id"
       textRole: "username"
       Layout.columnSpan: 3
    }

    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Name")
    }
    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cil-user"
        objectName: "username"
        Layout.fillWidth: true
        readOnly: initialValues
        enabled: !initialValues
    }

    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("First Name")
    }
    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cil-user"
        objectName: "first_name"
        Layout.fillWidth: true

    }
    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Last Name")
    }
    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cil-user"
        objectName: "last_name"
        Layout.fillWidth: true
    }

    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Phone")
    }
    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cil-phone"
        objectName: "phone"
        Layout.fillWidth: true
        helpBlock.text: qsTr("Invalid Phone Number")
        // validator: RegularExpressionValidator{
        //     regularExpression: /^(?:\d{2}-\d{3}-\d{3}-\d{3}|\d{11})$/
        // }
    }
    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Email")
    }
    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cib-mail-ru"
        objectName: "email"
        Layout.fillWidth: true

    }

    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Address")
    }

    CIconTextField {
        visible: !useExistingUser.checked

        leftIcon.name: "cil-location-pin"
        objectName: "address"
        Layout.fillWidth: true
    }

    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Password")
    }

    CIconTextField {
        id: tf
        visible: !useExistingUser.checked

        leftIcon.name: "cil-lock-locked"
        objectName: "password"
        Layout.fillWidth: true
        echoMode: TextInput.Password
        passwordToggleMask: true
    }


    CLabel {
        visible: !useExistingUser.checked

        text: qsTr("Role")
    }

    IconComboBox {
        id: cb
        visible: !useExistingUser.checked

        leftIcon.name: "cil-badge"
        objectName: "acl_group_id"
        valueRole: "id"
        textRole: "name"
        Layout.fillWidth: true


        model: AclGroupsModel{
            id: jsonModel
            onDataRecevied: {
                cb.model=jsonModel.toJsonArray();
                if(initialValues){
                    cb.currentIndex=cb.indexOfValue(initialValues[cb.objectName])
                }
            }
        }
    }
}
