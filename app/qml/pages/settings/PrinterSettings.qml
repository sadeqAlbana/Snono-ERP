import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe

AppPage {
    title: qsTr("General Settings")
    GridLayout {
        columns: 4
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label {
            text: qsTr("Receipt Printer")
        }
        IconComboBox {
            id: receiptPrinterCB
            leftIcon.name: "cil-printer"
            model: App.availablePrinters()

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.receiptPrinter)
        }

        Label {
            text: qsTr("Paper Size")
        }
        IconComboBox {
            id: receiptPaperSizeCB

            model: ['A4', 'A5', 'A6']
            leftIcon.name: "cil-page"

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.receiptPaperSize)
        }

        Label {
            text: qsTr("Reports Printer")
        }

        IconComboBox {
            id: reportsPrinterCB
            model: App.availablePrinters()
            leftIcon.name: "cil-printer"

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.reportsPrinter)
        }

        Label {
            text: qsTr("Paper Size")
        }
        IconComboBox {
            id: reportsPaperSizeCB
            model: ['A0', 'A1', 'A2', 'A3', 'A4', 'A5']
            leftIcon.name: "cil-page"

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.reportsPaperSize)
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
            Settings.reportsPrinter=reportsPrinterCB.currentValue
            Settings.receiptPrinter=receiptPrinterCB.currentValue
            Settings.receiptPaperSize=receiptPaperSizeCB.currentValue
            Settings.reportsPaperSize=reportsPaperSizeCB.currentValue

        }

        onCancel: {
            receiptCopies.currentIndex = receiptCopies.indexOfValue(
                        Settings.receiptCopies)
            externalReceiptCopies.currentIndex = externalReceiptCopies.indexOfValue(
                        Settings.externalReceiptCopies)
        }
    }
}
