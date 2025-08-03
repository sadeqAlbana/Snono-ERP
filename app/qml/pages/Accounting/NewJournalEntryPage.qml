import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import CoreUI.Palettes

CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    columns: 2
    title: qsTr("New Journal Entry")
    fillHeight: true

    NewJournalEntryModel {
        id: entriesModel
        records: [{
                "no": 1,
                "account": 1,
                "description": "test",
                "debit": 0,
                "credit": 500
            }]
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

        model: entriesModel
    } //TableView



    RowLayout {
        CButton {
            text: "+"
            palette: BrandInfo {}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            onClicked: entriesModel.newEntry();
        }

        CButton {
            text: qsTr("Reset")
            palette: BrandDanger {}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        }
    }
}
