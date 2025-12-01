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
    title: qsTr("Orders Return Details")
    link: "/orders/return/info"
    ColumnLayout {
        anchors.fill: parent
        // GridLayout{
        //     columns: 6
        //     CLabel{text: qsTr("ID");}
        //     CTextField{readOnly: true; text: page.dataRecord?.id?? ""}
        //     CLabel{text: qsTr("Reference");}
        //     CTextField{readOnly: true; text: page.dataRecord?.reference?? ""}
        //     CLabel{text: qsTr("Customer");}
        //     CTextField{readOnly: true; text: page.dataRecord?.customers?.name?? ""}

        //     CLabel{text: qsTr("Total");}
        //     CTextField{readOnly: true; text: page.dataRecord?.total?? ""}


        // }//GridLayout

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
                records: page.dataRecord?.order_return_items?? []
                columnList: [
                    JsonModelColumn {
                        displayName: qsTr("Product")
                        key: "name"
                        parentKey: "products"
                    },

                    JsonModelColumn {
                        displayName: qsTr("Unit Price")
                        key: "unit_price"
                        type: "currency"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Quantity")
                        key: "qty"
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
