import QtQuick
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts

AppFormDialog {
    title: qsTr("Add Vendor")
    applyHandler: Api.addVendor
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
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
}
