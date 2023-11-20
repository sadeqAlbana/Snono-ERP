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


    CTableView {
        id: tableView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        Layout.preferredHeight: 500
        Layout.alignment: Qt.AlignTop

        selectionBehavior: TableView.SelectCells


        model: JsonModel{
            id: draftModel
            columnList: [
            JsonModelColumn{key: "name"; displayName: "Name";},
            JsonModelColumn{key: "description"; displayName: "Description";},
            JsonModelColumn{key: "price"; displayName: "Price";},
            JsonModelColumn{key: "qty"; displayName: "Qty.";},
            JsonModelColumn{key: "total"; displayName: "Total";}
            ]

            function addEmptyRecord(){
                let record=draftModel.record;
                record["name"]=""
                record["description"]=""
                record["price"]=0;
                record["qty"]=1;
                record["total"]=0;

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
            text: qsTr("Save")
            palette: BrandSuccess{}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop

            // onClicked: Api.
            // setProductAttributes(general.initialValues.id,
            //                                     draftModel.toJsonArray()).subscribe(function(res){
            //     console.log(JSON.stringify(res.json()))
            //     if(res.json('status')===200){
            //         Router.back();
            //     }
            // })


        }

        CButton{
            text: qsTr("Reset")
            palette: BrandDanger{}
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
        }

    }

} //card End
