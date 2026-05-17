import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Views
Card{
    id: page
    title: qsTr("Customer")
    property alias initialValues: general.initialValues
    property var keyValue: null
    property bool readOnly: false //useless for now, used to avoid syntax error
    CTabView{
        anchors.fill: parent;
        CFormView {
            id: general
            padding: 10
            rowSpacing: 30
            title: qsTr("Info")
            url: "/customer"
            keyValue: page.keyValue
            columns: 4
            CLabel {
                text: qsTr("Name")
            }
            CIconTextField {
                leftIcon.name: "cil-user"
                objectName: "name"
                Layout.fillWidth: true
            }

            // CLabel {
            //     text: qsTr("First Name")
            // }
            // CIconTextField {
            //     leftIcon.name: "cil-user"
            //     objectName: "first_name"
            //     Layout.fillWidth: true
            // }
            // CLabel {
            //     text: qsTr("Last Name")
            // }
            // CIconTextField {
            //     leftIcon.name: "cil-user"
            //     objectName: "last_name"
            //     Layout.fillWidth: true
            // }

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
                objectName: "address_line"
                Layout.fillWidth: true
            }

            CLabel {
                text: qsTr("Roles")
            }
            RowLayout {
                Layout.fillWidth: true
                Layout.columnSpan: 3
                spacing: 12
                CheckBox { objectName: "is_customer"; text: qsTr("Customer"); checked: true }
                CheckBox { objectName: "is_vendor";   text: qsTr("Vendor") }
                CheckBox { objectName: "is_owner";    text: qsTr("Owner");   enabled: AuthManager.hasPermission("prm_admin") }
                CheckBox { objectName: "is_driver";   text: qsTr("Driver") }
                CheckBox { objectName: "is_carrier";  text: qsTr("Carrier"); enabled: AuthManager.hasPermission("prm_admin") }
                CheckBox { objectName: "is_employee"; text: qsTr("Employee") }
            }
        }

        CPage{
        title: qsTr("Adresses")
        GridView{
            clip: true

            anchors.fill: parent
            model: page.initialValues?.adresses

            cellWidth: 400
            cellHeight: 250
            delegate: AddressDelegate{

            }

        }
        }
    }


}
