import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Forms
import CoreUI.Views

CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    columns: 2
    title: qsTr("New Journal Entry")

    fillHeight: true
    CLabel {
        text: qsTr("Description")
    }
    CIconTextField {
        leftIcon.name: "cil-description"
        objectName: "description"
        Layout.fillWidth: true
    }

    CLabel {
        id: label
        Layout.columnSpan: 2


        text: qsTr("Details")
    }

        CTableView {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            Layout.fillHeight: true
            id: tableView

            selectionBehavior: TableView.SelectCells


            model: NewJournalEntryModel{
                records: [{"no":1,"account": 1,"description":"test","debit": 0,"credit": 500}]

            }

        }//TableView


}
