import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"

import QtGraphicalEffects 1.0
import app.models 1.0

Card{

    title: qsTr("Categories")

    ColumnLayout{
        id: page
        anchors.fill: parent;
        anchors.margins: 20
        RowLayout{
            spacing: 15

            Rectangle{
                Layout.fillWidth: true
                color: "transparent"
            }

            Label{
                text: qsTr("Search")
                font.pixelSize: 18
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            }

            TestTextField{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
            }
        }

        CListView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [Action{ text: "Delete"; icon.source: "qrc:/assets/icons/coreui/free/cil-copy.svg"; onTriggered: tableView.removeCategory()}]

            model: CategoriesModel{
                id: model;

                onCategoryRemoveReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end

            } //model end

            function removeCategory(){
                var categoryId= model.data(tableView.currentIndex,"id");
                model.removeCategory(categoryId);
            }

        }
    }
}

