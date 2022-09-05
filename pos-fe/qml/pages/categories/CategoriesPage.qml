import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/common"

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
                Action{ text: "Delete"; icon.name: "cil-delete"; onTriggered: tableView.removeCategory()}]

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

