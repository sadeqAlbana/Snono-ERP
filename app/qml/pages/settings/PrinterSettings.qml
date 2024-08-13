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
            text: qsTr("Line Printer")
        }
        IconComboBox {
            id: linePrinterCB
            leftIcon.name: "cil-printer"
            model: App.availablePrinters()

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.linePrinter)
        }

        Label {
            text: qsTr("Paper Size")
        }

        IconComboBox {
            id: linePrinterPaperSizeCB

            model: ['57mm','80mm']
            leftIcon.name: "cil-page"

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.linePrinterPaperSize)
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

        Label {
            text: qsTr("Receipt copies with External Delivery")
        }
        IconComboBox {
            id: receiptCopiesWithExternalDelivery
            leftIcon.name: "cil-page"
            model: [1, 2, 3, 4, 5]
            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.receiptCopiesWithExternalDelivery)
        }

        HorizontalSpacer{
            Layout.columnSpan: 2
        }


        Label {
            text: qsTr("Label Printer")
        }

        IconComboBox {
            id: labelPrinterCB
            model: App.availablePrinters()
            leftIcon.name: "cil-printer"

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.labelPrinter)
        }

        CLabel {
            text: qsTr("Label Size Unit")
        }


        IconComboBox {
            id: labelSizeUnitCB
            leftIcon.name: "cil-page"
            model: Settings.qPageSizeUnits();

            valueRole: "value";
            textRole: "key";

            Component.onCompleted: currentIndex = indexOfValue(
                                       Settings.labelPrinterLabelSizeUnit)

        }

        CLabel {
            text: qsTr("Label Width")
        }
        CIconTextField{
            id: labelPrinterLabelWidth
            leftIcon.name: "cil-resize-width"
            text: Settings.labelPrinterLabelWidth
            validator: RegularExpressionValidator {
                 regularExpression: /^-?\d+(\.\d{1,2})?$/
             }

        }
        CLabel {
            text: qsTr("Label Height")
        }
        CIconTextField{
            id: labelPrinterLabelHeight
            leftIcon.name: "cil-resize-height"
            text: Settings.labelPrinterLabelHeight

            validator: RegularExpressionValidator {
                 regularExpression: /^-?\d+(\.\d{1,2})?$/
             }
        }


    }

    footer: AppDialogFooter {
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {
            Settings.receiptCopies = receiptCopies.currentValue
            Settings.receiptCopiesWithExternalDelivery = receiptCopiesWithExternalDelivery.currentValue
            Settings.receiptPrinter=receiptPrinterCB.currentValue
            Settings.linePrinter=linePrinterCB.currentValue

            Settings.externalReceiptCopies = externalReceiptCopies.currentValue
            Settings.reportsPrinter=reportsPrinterCB.currentValue
            Settings.labelPrinter=labelPrinterCB.currentValue

            Settings.receiptPaperSize=receiptPaperSizeCB.currentValue
            Settings.linePrinterPaperSize=linePrinterPaperSizeCB.currentValue

            Settings.reportsPaperSize=reportsPaperSizeCB.currentValue

            Settings.labelPrinterLabelWidth=labelPrinterLabelWidth.text
            Settings.labelPrinterLabelHeight=labelPrinterLabelHeight.text
            Settings.labelPrinter=labelPrinterCB.currentValue;
            Settings.labelPrinterLabelSizeUnit=labelSizeUnitCB.currentValue

        }

        onCancel: {
            receiptCopies.currentIndex = receiptCopies.indexOfValue(
                        Settings.receiptCopies)
            receiptCopiesWithExternalDelivery.currentIndex = receiptCopiesWithExternalDelivery.indexOfValue(
                        Settings.receiptCopiesWithExternalDelivery)
            externalReceiptCopies.currentIndex = externalReceiptCopies.indexOfValue(
                        Settings.externalReceiptCopies)
        }
    }


}
