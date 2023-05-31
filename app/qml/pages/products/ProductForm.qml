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
import CoreUI.Views
CTabView{
    id: tabView
    property var initialValues: null

    CFormView{
        title: qsTr("Data")
        padding: 10
        rowSpacing: 30
        header.visible: false
        applyHandler: null
        initialValues: tabView.initialValues
            CLabel {
                text: qsTr("Name")
            }
            CIconTextField {
                leftIcon.name: "cil-pencil"
                objectName: "name"
                Layout.fillWidth: true
            }

            CLabel {
                text: qsTr("Description")
            }
            CIconTextField {
                leftIcon.name: "cil-description"
                objectName: "description"
                Layout.fillWidth: true

            }
            CLabel {
                text: qsTr("Barcode")
            }
            CIconTextField {
                leftIcon.name: "cil-barcode"
                objectName: "barcode"
                Layout.fillWidth: true
            }

            CLabel {
                text: qsTr("List Price")
            }
            CIconTextField {
                leftIcon.name: "cil-money"
                objectName: "list_price"
                Layout.fillWidth: true
            }
            CLabel {
                text: qsTr("Cost")
            }
            CIconTextField {
                leftIcon.name: "cil-money"
                objectName: "cost"
                Layout.fillWidth: true

            }


    }



}
