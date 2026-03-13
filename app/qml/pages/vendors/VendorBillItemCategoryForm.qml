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
    title: qsTr("Category")
    url: "/vendorBillItemCategory"


    columns: 2
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-linear"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel{
        text: qsTr("Parent Category")
    }

    CFilterComboBox{
        Layout.fillWidth: true
        objectName: "account_id"
        textRole: "name"
        valueRole: "id"
        dataUrl: "/accounts/list"
    }
}
