import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe

AppPage{
    title: qsTr("Categories")
    padding: 10

    Connections{
        target: Api
        function onCategoryRemoveReply(reply) {
            if(reply.status===200){
                categoriesModel.requestData();
            }
        } //slot end
    }//connections
    AddCategoryDialog{
        id: dialog;
    }
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
//            title: "categories"
            actions: [
                Action{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: dialog.open()},
                Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeCategory()}]

            model: CategoriesModel{
                id: categoriesModel;
            } //model end

            function removeCategory(){
                var categoryId = categoriesModel.data(tableView.currentIndex,"id");
                Api.removeCategory(categoryId);
            }
        }//listView
    }//layout
}

