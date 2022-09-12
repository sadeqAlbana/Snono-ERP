import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import App.Models
import QtQuick.Dialogs
import QtCore
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

AppPage{
    title: "General Settings"
    GridLayout{
        columns: 4
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label{
            text: qsTr("Receipt Printer");
        }
        CComboBox{
            id: receiptPrinter
            icon.name: "cil-printer"
            model: App.availablePrinters();
        }

        Label{
            text: qsTr("Paper Size");
        }
        CComboBox{
            icon.name: "cil-page"
            model: ['A4','A5','A6']
        }

        Label{
            text: qsTr("Reports Printer");
        }

        CComboBox{
            model: App.availablePrinters();
            icon.name: "cil-printer"
        }

        Label{
            text: qsTr("Paper Size");
        }
        CComboBox{
            icon.name: "cil-page"
            model: ['A0','A1','A2','A3','A4','A5']
        }
    }

    footer: AppDialogFooter{
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {


            }

        }


}
