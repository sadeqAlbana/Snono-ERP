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
    url: "/jobTitle"
    title: qsTr("Job Title")

    CLabel { text: qsTr("Name") }
    CIconTextField {
        leftIcon.name: "cil-tag"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel { text: qsTr("Default Salary") }
    CNumberInput {
        objectName: "default_salary"
        Layout.fillWidth: true
    }
}
