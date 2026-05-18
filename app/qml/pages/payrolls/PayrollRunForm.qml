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
    url: "/payrollRun"
    title: qsTr("Payroll Run")

    CLabel { text: qsTr("Name") }
    CIconTextField {
        leftIcon.name: "cil-tag"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel { text: qsTr("Period Start") }
    CDateInput {
        objectName: "period_start"
        Layout.fillWidth: true
    }

    CLabel { text: qsTr("Period End") }
    CDateInput {
        objectName: "period_end"
        Layout.fillWidth: true
    }

    CLabel { text: qsTr("Notes") }
    CIconTextField {
        leftIcon.name: "cil-notes"
        objectName: "notes"
        Layout.fillWidth: true
    }
}
