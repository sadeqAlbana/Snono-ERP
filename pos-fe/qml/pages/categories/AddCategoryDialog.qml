import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtGraphicalEffects 1.0
import app.models 1.0
Popup{

    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay

    width: parent.width*0.4
    height: parent.height*0.4
    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }


    Card{
        id: card
        title: qsTr("Add Category")
        anchors.fill: parent;

        ColumnLayout{
            anchors.margins: 10
            anchors.fill: parent;
            spacing: 10


            CTextInputGroup{id: nameLE; label.text: "Category Name"}

            CComboBoxGroup{
                id: categoriesCB
                Layout.fillWidth: true
                label.text: "Parent Category"
                comboBox.textRole: "category"
                comboBox.model: CategoriesModel{
                    id: model;

                    onCategoryAddReply: {
                        if(reply.status===200){
                            toastrService.push("Success",reply.message,"success",2000)
                            model.requestData();

                        }
                        else{
                            toastrService.push("Error",reply.message,"error",2000)
                        }
                    }
                }

            }




        } //layout end

        function addCategory(){
            var parentId= model.data(categoriesCB.comboBox.currentIndex,"id");
            var name=nameLE.text;
            model.addCategory(name,parentId);
        }

        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Close")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Add")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: card.addCategory();
            }

        } //footer end

    } //card end

}
