import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import PosFe

AppPage {
    title: "General Settings"
    GridLayout {
        columns: 4
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label {
            text: qsTr("Receipt Printer")
        }
        IconComboBox {
            id: receiptPrinter
            leftIcon.name: "cil-printer"
            model: App.availablePrinters()
        }

        Label {
            text: qsTr("Paper Size")
        }
        IconComboBox {
            leftIcon.name: "cil-page"
            model: ['A4', 'A5', 'A6']
        }

        Label {
            text: qsTr("Reports Printer")
        }

        IconComboBox {
            model: App.availablePrinters()
            leftIcon.name: "cil-printer"
        }

        Label {
            text: qsTr("Paper Size")
        }
        IconComboBox {
            leftIcon.name: "cil-page"
            model: ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']
        }

        Label {
            text: qsTr("Receipt copies")
        }
        IconComboBox {
            id: receiptCopies
            leftIcon.name: "cil-page"
            model: [1, 2, 3, 4, 5]
            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.receiptCopies)
        }

        Label {
            text: qsTr("External Receipt copies")
        }
        IconComboBox {
            id: externalReceiptCopies
            leftIcon.name: "cil-page"
            model: [1, 2, 3, 4, 5]
            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.externalReceiptCopies)
        }
    }

    footer: AppDialogFooter {
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {
            Settings.receiptCopies = receiptCopies.currentValue
            Settings.externalReceiptCopies = externalReceiptCopies.currentValue
        }

        onCancel: {
            receiptCopies.currentIndex = receiptCopies.indexOfValue(Settings.receiptCopies)
            externalReceiptCopies.currentIndex = externalReceiptCopies.indexOfValue(Settings.externalReceiptCopies)

        }
    }
}
