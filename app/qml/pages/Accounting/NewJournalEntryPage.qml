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
    header.visible: true
    columns: 2
    title: qsTr("Account")
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
        Layout.fillWidth: true
    }




}
