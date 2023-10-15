import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

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
    title: qsTr("Journal Entry Details")
    link: "/journalEntry"
    ColumnLayout {
        anchors.fill: parent
        GridLayout{
            columns: 6
            CLabel{text: qsTr("ID");}
            CTextField{readOnly: true; text: page.dataRecord?.id?? ""}
            CLabel{text: qsTr("Reference");}
            CTextField{readOnly: true; text: page.dataRecord?.reference?? ""}
//            CLabel{text: qsTr("Customer");}
//            CTextField{readOnly: true; text: page.dataRecord?.customers?.name?? ""}

//            CLabel{text: qsTr("Total");}
//            CTextField{readOnly: true; text: page.dataRecord?.total?? ""}

//            CLabel{text: qsTr("Phone");}
//            CTextField{readOnly: true; text: page.dataRecord?.customers?.phone?? ""}

//            CLabel{text: qsTr("Address");}
//            CTextField{readOnly: true; text: page.dataRecord?.customers?.address?? ""}

        }//GridLayout

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
                records: page.dataRecord?.items?? []
                columnList: [
                    JsonModelColumn {
                        displayName: qsTr("Account")
                        key: "name"
                        parentKey: "account"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Credit")
                        key: "credit"
                        type: "currency"
                    },
                    JsonModelColumn {
                        displayName: qsTr("Debit")
                        key: "debit"
                        type: "currency"
                    }
                ]
            }
        }//TableView
    }//ColumnLayout
}
