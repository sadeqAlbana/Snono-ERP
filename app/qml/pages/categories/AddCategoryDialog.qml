import QtQuick;
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects

import PosFe
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
        Connections{
            target: Api
            function onCategoryAddReply(reply){
                if(reply.status===200){
                    model.requestData();
                }
            }//slot
        }//connections
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

                }//model
            }//cb
        } //layout

        function addCategory(){
            var parentId= model.data(categoriesCB.comboBox.currentIndex,"id");
            var name=nameLE.text;
            Api.addCategory(name,parentId);
        }

        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Close")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: dialog.close();
            }

            CButton{
                text: qsTr("Add")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: card.addCategory();
            }

        } //footer end

    } //card end
}//Popup
