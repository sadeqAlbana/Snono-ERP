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

    property var accounts: undefined



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
                "account_id": 3,
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
        text: qsTr("Date")
    }
    CDateInput {
        objectName: "date"
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
            DelegateChoice{ roleValue: "combo"; CTableViewDelegate{
                    text: accounts? accounts.find(obj => obj.id === model.display).account : "N.A"
                    TableView.editDelegate: CComboBox{
                    width: parent.width
                    height: parent.height
                    model: accounts;
                    valueRole: "id"
                    textRole: "account"
                    editable: true
                    TableView.onCommit: display = currentValue

                    onCurrentIndexChanged: {
                        let result= accounts.find(obj => obj.id == model.display)
                        console.log("display: "  + JSON.stringify(result))

                    }

                    Component.onCompleted: currentIndex=indexOfValue(display)
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
