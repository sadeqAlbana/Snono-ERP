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

Card {
    id: page
    property alias initialValues: general.initialValues
    title: qsTr("Product Form")
    property var keyValue: null
    property bool readOnly: false //useless for now, used to avoid syntax error
    CTabView {
        id: tabView
        anchors.fill: parent
        CFormView {
            id: general
            title: qsTr("General")
            padding: 10
            rowSpacing: 30
            header.visible: false
            keyValue: page.keyValue
            url: "/product"
            CLabel {
                text: qsTr("Name")
            }
            CIconTextField {
                leftIcon.name: "cil-pencil"
                objectName: "name"
                Layout.fillWidth: true
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
                text: qsTr("Barcode")
            }
            CIconTextField {
                leftIcon.name: "cil-barcode"
                objectName: "barcode"
                Layout.fillWidth: true
            }

            CLabel {
                text: qsTr("List Price")
            }
            SpinBox {
                //leftIcon.name: "cil-money"
                objectName: "list_price"
                Layout.fillWidth: true
                editable: true
                to: 100000000

            }
            CLabel {
                text: qsTr("Cost")
            }
            SpinBox {
                //leftIcon.name: "cil-money"
                objectName: "cost"
                Layout.fillWidth: true
                editable: true
                to: 100000000

            }

            CLabel{
                text: qsTr("Type")
            }

            IconComboBox{
                objectName: "type"
                enabled: !keyValue
                Layout.fillWidth: true
                textRole: "text"
                valueRole: "value"
                model:ListModel {
                    ListElement { text: qsTr("Storable Product");   value: 1;}
                    ListElement { text: qsTr("Consumable Product"); value: 2;}
                    ListElement { text: qsTr("Service Product");    value: 3;}
                }
            }

            CLabel{
                text: qsTr("Costing Method")
            }

            IconComboBox{
                objectName: "costing_method"
                enabled: !keyValue
                Layout.fillWidth: true
                textRole: "text"
                valueRole: "value"
                model:ListModel {
                    ListElement { text: qsTr("FIFO");   value: "FIFO";}
                    ListElement { text: qsTr("AVCO");    value: "AVCO";}
                }
            }

            CLabel{
                text: qsTr("Category")
            }

            CFilterComboBox{
                Layout.fillWidth: true
                objectName: "category_id"
                textRole: "name"
                valueRole: "id"
                dataUrl: "/categories"
            } //end categoryCB


            CLabel{
                text: qsTr("Taxes")
            }

            CCheckableComboBox{
                Layout.fillWidth: true
                //           Layout.maximumWidth: parent.width/2
                model: TaxesCheckableModel{
                    id: taxesModel;
                }
                textRole: "name";
                valueRole: "id"
                displayText: taxesModel.selectedItems==="" ? qsTr("select Taxes...") : taxesModel.selectedItems;

            }



            CCheckBox{
                id: haveVariants
                text: qsTr("Have Variants")
                Layout.columnSpan: 2
                objectName: "have_variants"
            }


            CLabel{
                text: qsTr("Parent Product")
            }

            CFilterComboBox{
                id: cb
                enabled: !haveVariants.checked
                Layout.fillWidth: true
                objectName: "parent_id"
//                defaultEntry: {"id:":-1, "name": "None"}
                filter: {"parent_id":null}
                dataUrl: "/products/list"
                valueRole: "id";
                textRole: "name";
                defaultEntry: {"id": 0, "name": qsTr("None")}
            }

        } //General

        JsonModel {
            id: attributesModel
            records: general.initialValues?.attributes?? []


            columnList: [

                JsonModelColumn{ displayName: qsTr("Attribute");key: "attribute_id";},
                JsonModelColumn{ displayName: qsTr("Value");key: "value";}
//                JsonModelColumn{ displayName: qsTr("Type");key: "type";parentKey: "attributes_attribute";}
//                JsonModelColumn{ displayName: qsTr("created_at");key: "created_at";}


            ]
        }

        Card {
            title: qsTr("Attributes")

            header.visible: false

            ColumnLayout {
                anchors.fill: parent
                CTableView {
                    id: tableView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop

                    selectionBehavior: TableView.SelectCells

                    model: ProductAttributesProxyModel {

                        sourceModel: attributesModel
                    }

                    reuseItems: false

                    selectionModel: ItemSelectionModel {}

                    alternatingRows: true
                    animate: true

                    delegate: DelegateChooser {
                        role: "delegateType"
                        DelegateChoice {
                            roleValue: "text"

                            delegate: CTableViewDelegate {}
                        }
                        DelegateChoice {
                            roleValue: "action"
                            delegate: ActionsDelegate {

                                CButton {
                                    text: "x"
                                    palette: BrandDanger {}

                                    Layout.alignment: Qt.AlignCenter
                                    onClicked: attributesModel.removeRecord(row)
                                }
                            }
                        }

                        DelegateChoice {
                            roleValue: "combo"
                            delegate: CTableViewDelegate {
                                id: del
                                TableView.editDelegate: CComboBox{
                                    width: parent.width
                                    height: parent.height
                                    TableView.onCommit: {
                                        edit = currentText
                                    }
                                    model:["text","image"]
                                    Component.onCompleted: {
                                        console.log("iov:  " + indexOfValue(edit))
                                    }

                                }
                            }
                        }
                    }
                }//TableView

                RowLayout{
                    CButton{
                        text: "+"
                        palette: BrandInfo{}
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        onClicked: attributesModel.appendRecord(attributesModel.record)
                    }
                    CButton{
                        text: qsTr("Save")
                        palette: BrandSuccess{}
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop

                        onClicked: Api.
                        setProductAttributes(general.initialValues.id,
                                                            attributesModel.toJsonArray()).subscribe(function(res){
                            console.log(JSON.stringify(res.json()))
                            if(res.json('status')===200){
                                Router.back();
                            }
                        })


                    }

                    CButton{
                        text: qsTr("Reset")
                        palette: BrandDanger{}
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                    }

                }

//                VerticalSpacer{}
            }
        }
    } //tabview
}
