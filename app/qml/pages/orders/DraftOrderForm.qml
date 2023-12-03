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
import Qt.labs.qmlmodels
import JsonModels
import "qrc:/PosFe/qml/screens/utils.js" as Utils
CFormView {
    url: "/draftOrder"

    CLabel {
        text: qsTr("Name")
    }
    CTextField {
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Customer")
    }

    CComboBox {
        objectName: "customer_id"
        Layout.fillWidth: true
        textRole: "name"
        valueRole: "id"
        currentIndex: 0
        model: CustomersModel {}
    }


    CLabel {
        text: qsTr("Description")
    }
    CTextArea {
        objectName: "description"
        Layout.fillWidth: true
    }

    CTableView {
        id: tableView
        objectName: "items"
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        Layout.preferredHeight: 500
        Layout.alignment: Qt.AlignTop

        selectionBehavior: TableView.SelectCells


        model: DraftOrderFormModel{
            id: draftModel



            function addEmptyRecord(){
                let record=draftModel.record;
                record["name"]=""
                record["description"]=""
                record["unit_price"]=1000;
                record["qty"]=1;
                record["total"]=1000;

                draftModel.appendRecord(record)
            }
        }

        reuseItems: false

        selectionModel: ItemSelectionModel {}

        alternatingRows: true
        animate: true

        delegate: AppDelegateChooser {

            DelegateChoice {
                roleValue: "action"
                delegate: ActionsDelegate {

                    CButton {
                        text: "x"
                        palette: BrandDanger {}

                        Layout.alignment: Qt.AlignCenter
                        onClicked: draftModel.removeRecord(row)
                    }
                }
            }

        }
    }//TableView

    RowLayout{
        Layout.columnSpan: 2

        CButton{
            text: "+"
            palette: BrandInfo{}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            onClicked: draftModel.addEmptyRecord();
        }


        CButton{
            text: qsTr("Reset")
            palette: BrandDanger{}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            onClicked: draftModel.records=[];
        }

    }

} //card End
