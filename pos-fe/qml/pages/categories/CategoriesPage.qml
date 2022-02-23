import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.0
import app.models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/common"

Card{
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

    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
        }
        AddCategoryDialog{
            id: dialog;
        }
        CListView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            title: "categories"
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

