import QtQuick;
import QtQuick.Controls.Basic;
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
AppPage{
    title: qsTr("Stock Report")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            view: tableView
            searchVisible: true

            onFilterClicked: (filter) => {
                                 model.filter=filter
                                 model.requestData();
                             }

            onSearch: searchString => {
                          var filter = model.filter
                          filter['query'] = searchString
                          model.filter = filter
                          model.requestData()
                      }

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

//            delegate: AppDelegateChooser{}

            actions: [
                CAction{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
            ]

            delegate: AppDelegateChooser{}

            model: AppNetworkedJsonModel{
                url: "reports/monthlyFinance"
                columnList: [

                    JsonModelColumn{
                        key: "month"
                        displayName: qsTr("Month")
                        type: "date"
                    },
                    JsonModelColumn{
                        key: "sales"
                        displayName: qsTr("Sales")
                        type: "currency"
                    },
                    JsonModelColumn{
                        key: "sales_returns"
                        displayName: qsTr("Sales Returns")
                        type: "currency"
                    },
                    JsonModelColumn{
                        key: "cost_of_goods_sold"
                        displayName: qsTr("Cogs")
                        type: "currency"
                    },
                    JsonModelColumn{
                        key: "expenses"
                        displayName: qsTr("Expenses")
                        type: "currency"
                    },
                    JsonModelColumn{
                        key: "gross_profit"
                        displayName: qsTr("Gross Profits")
                        type: "currency"
                    }

                ]

            }//model

        }
    }
}

