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

AppPage{
    title: qsTr("Wharehouses")


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
                CAction{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: dialog.open()},
                CAction{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeCategory()}]

            model: StockLocationModel{
                id: model;
            } //model end


        }//listView
    }//layout
}

