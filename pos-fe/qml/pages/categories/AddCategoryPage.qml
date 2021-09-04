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

Card{
    title: qsTr("Add Category")


    ColumnLayout{
        anchors.margins: 10
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: parent.width*0.7
        spacing: 20


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

        CButton{
            text: qsTr("Add")
            color: "#2eb85c"
            textColor: "#ffffff"
            implicitHeight: 60
            Layout.margins: 10
            onClicked: parent.addCategory();
        }

        function addCategory(){
            var parentId= model.data(categoriesCB.comboBox.currentIndex,"id");
            var name=nameLE.text;
            model.addCategory(name,parentId);
        }

    } //layout end



} //card end
