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
    property var initialValues: null
    property var applyHandler
    Component.onCompleted: console.log(JSON.stringify(initialValues))
    CTabView {
        id: tabView
        anchors.fill: parent
        CFormView {
            title: qsTr("General")
            padding: 10
            rowSpacing: 30
            header.visible: false
            applyHandler: function () {}
            initialValues: page.initialValues
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
            CIconTextField {
                leftIcon.name: "cil-money"
                objectName: "list_price"
                Layout.fillWidth: true
            }
            CLabel {
                text: qsTr("Cost")
            }
            CIconTextField {
                leftIcon.name: "cil-money"
                objectName: "cost"
                Layout.fillWidth: true
            }
        }

        JsonModel {
            id: attributesModel
            records: initialValues?.attributes?? []

            columnList: [

                JsonModelColumn{ displayName: qsTr("Attribute");key: "attribute_id";},
                JsonModelColumn{ displayName: qsTr("Value");key: "value";}

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
