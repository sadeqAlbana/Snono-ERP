import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    method: control.method
    url: control.url

    header.visible: true



    columns: 4
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "username"
        Layout.fillWidth: true
        readOnly: initialValues
        enabled: !initialValues
    }

    CLabel {
        text: qsTr("First Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "first_name"
        Layout.fillWidth: true
    }
    CLabel {
        text: qsTr("Last Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "last_name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Phone")
    }
    CIconTextField {
        leftIcon.name: "cil-phone"
        objectName: "phone"
        Layout.fillWidth: true
    }
    CLabel {
        text: qsTr("Email")
    }
    CIconTextField {
        leftIcon.name: "cib-mail-ru"
        objectName: "email"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Address")
    }

    CIconTextField {
        leftIcon.name: "cil-location-pin"
        objectName: "address"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Role")
    }

    IconComboBox {
        id: cb
        leftIcon.name: "cil-badge"
        objectName: "acl_group_id"
        valueRole: "id"
        textRole: "name"
        Layout.fillWidth: true
        model: AclGroupsModel{
//            Component.onCompleted: requestData();
            onDataRecevied: {
                console.log("indexofvalue: " + cb.indexOfValue(0))
                cb.currentIndex=cb.indexOfValue(0);

                console.log("setted current index")
                cb.modelChanged()

            }
        }
    }
}
