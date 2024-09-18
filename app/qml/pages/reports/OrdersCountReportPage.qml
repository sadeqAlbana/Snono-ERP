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
    title: qsTr("Orders count")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            view: tableView
            searchVisible: true


            advancedFilter: [
                {
                    "type": "combo",
                    "label": qsTr("product"),
                    "key": "products",
                    "options": {
                        "checkable": false,
                        "editable": true,
                        "defaultEntry": {
                            "name": qsTr("All Products"),
                            "id": null
                        },
                        "textRole": "name",
                        "valueRole": "id",
                        "dataUrl": "/products/list",
                        "filter": {
                            "onlyVariants": true
                        }
                    }
                }, {
                    "type": "date",
                    "label": qsTr("from"),
                    "key": "from"
                }, {
                    "type": "date",
                    "label": qsTr("to"),
                    "key": "to"
                }, {
                    "type": "checkableCombo",
                    "label": qsTr("type"),
                    "key": "order_types",
                    "options": {
                        "checkable": true,
                        "editable": false,
                        "textRole": "name",
                        "valueRole": "value",
                        "values": [{"name": qsTr("POS"),"value":"pos"},{"name": qsTr("Online"),"value":"online"}]
                    }
                }, {
                    "type": "combo",
                    "label": qsTr("Group By"),
                    "key": "group_by",
                    "options": {
                        "checkable": false,
                        "editable": false,
                        "textRole": "name",
                        "valueRole": "value",
                        "defaultEntry": {},
                        "values": [{"name": qsTr("Month"),"value":"month"},{"name": qsTr("Year"),"value":"year"},{"name": qsTr("Day"),"value":"day"}]
                    }
                }]

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

            model: OrdersCountReportModel{
                id: model

            }//model

        }
    }
}

