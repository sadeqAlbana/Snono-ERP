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
    title: qsTr("New Invoice")
    fillHeight: true
    method: "POST"
    url: "/invoice"


    Component.onCompleted: {
        NetworkManager.get("/customer/list").subscribe(
                    function (response) {
                        journalsCB.model = response.json("data");
                    });

    }


    NewInvoiceModel {
        id: invoiceModel
        // records: [{
        //         "no": 1,
        //         "account_id": 3,
        //         "description": "test",
        //         "debit": 0,
        //         "credit": 500
        //     }]
    }

    CLabel {
        text: qsTr("Customer")
    }
    CComboBox {
        id: journalsCB
        objectName: "customer_id"
        valueRole: "id"
        textRole: "name"
        Layout.fillWidth: true
        editable: true
    }


    CLabel {
        text: qsTr("Name")
    }
    CTextField {
        objectName: "name"
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
        objectName: "items"
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        selectionBehavior: TableView.SelectCells
        delegate: AppDelegateChooser{

        }

        model: invoiceModel
    } //TableView



    RowLayout {
        CButton {
            text: "+"
            palette: BrandInfo {}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            onClicked: invoiceModel.newEntry();
        }

        CButton {
            text: qsTr("Reset")
            palette: BrandDanger {}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        }
    }
}
