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

    property var accounts;

    Component.onCompleted: {
        NetworkManager.get("/accounts/list").subscribe(
                    function (response) {
                        accounts = response.json("data");
                    });

    }


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
    CTextField {
        objectName: "description"
        Layout.fillWidth: true
    }

    CLabel {
        id: label
        Layout.columnSpan: 2

        text: qsTr("Details")
    }

    CTableView {
        id: tableView
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        selectionBehavior: TableView.SelectCells
        delegate: AppDelegateChooser{
            DelegateChoice{ roleValue: "combo";       CTableViewDelegate{

                    TableView.editDelegate: CComboBox{
                    width: parent.width
                    height: parent.height
                    model: accounts;
                    valueRole: "id"
                    textRole: "name"
                    Component.onCompleted: console.log("created...");
                    }

                }}

        }

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
