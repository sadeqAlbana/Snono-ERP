import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import JsonModels

AppDataPage {
    id: page
    title: qsTr("Orders Details")
    link: "/order"
    ColumnLayout {
        anchors.fill: parent

        Label{
            Layout.leftMargin: 15
            Layout.topMargin: 5
            font.bold: true
            font.pixelSize: 22
            text: qsTr("Details:")
        }

        GridLayout{
            Layout.leftMargin: 15
            Layout.bottomMargin: 15
            columns: 2
            columnSpacing: 45
            CLabel{font.pixelSize: 18; text: qsTr("ID:");}
            CLabel{font.pixelSize: 18; color: "#000"; text: page.dataRecord?.id?? ""}
            CLabel{font.pixelSize: 18; text: qsTr("Reference:");}
            CLabel{font.pixelSize: 18; color: "#000"; text: page.dataRecord?.reference?? ""}
            CLabel{font.pixelSize: 18; text: qsTr("Customer:");}
            CLabel{font.pixelSize: 18; color: "#000"; text: page.dataRecord?.customers?.name?? ""}
            CLabel{font.pixelSize: 18; text: qsTr("Total:");}
            CLabel{font.pixelSize: 18; color: "#000"; text: Utils.formatCurrency(page.dataRecord?.total?? "0")}

        }//GridLayout


        CHorizontalSeperator{}
        CTableView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            rowHeightProvider: function (row) {
                return 50
            }
            delegate: DelegateChooser {
                role: "delegateType"
                DelegateChoice {
                    roleValue: "text"
                    CTableViewDelegate {}
                }
                DelegateChoice {
                    roleValue: "currency"
                    CurrencyDelegate {}
                }
                DelegateChoice {
                    roleValue: "percentage"
                    SuffixDelegate {
                        suffix: "%"
                    }
                }
            }

            model: JsonModel {
                records: page.dataRecord?.order_items?? []
                columnList: [
                    JsonModelColumn {
                        displayName: qsTr("Product")
                        key: "name"
                        parentKey: "products"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Quantity")
                        key: "qty"
                    },


                    JsonModelColumn {
                        displayName: qsTr("Unit Price")
                        key: "unit_price"
                        type: "currency"
                    },

                    JsonModelColumn {
                        displayName: qsTr("Discount")
                        key: "discount"
                        type: "percentage"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Subtotal")
                        key: "subtotal"
                        type: "currency"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Total")
                        key: "total"
                        type: "currency"
                    }
                ]
            }
        }//TableView
    }//ColumnLayout
}
