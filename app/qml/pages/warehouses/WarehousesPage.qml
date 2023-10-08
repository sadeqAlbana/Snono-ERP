import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
AppPage{
    title: qsTr("Warehouses")


    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            view: tableView

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
//            title: "categories"
            actions: [
                CAction {
                    text: qsTr("Add")
                    icon.name: "cil-plus"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/warehouses/WareHouseForm.qml",{
                                                     "title": qsTr("Add")
                                                 })

                },
                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/warehouses/WareHouseForm.qml",
                                                 {
                                                     "title": qsTr("Edit"),

                                                     "keyValue": model.jsonObject(tableView.currentRow).id
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_warehouses";

                },
                CAction {
                    text: qsTr("Delete")
                    icon.name: "cil-delete"
//                    onTriggered: tableView.removeVendor();
                }
            ]

            model: StockLocationModel{
                id: model;
            } //model end


        }//listView
    }//layout
}

