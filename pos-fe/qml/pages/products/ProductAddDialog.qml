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
import "qrc:/common"

AppDialog{

    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay

    width:  Math.max(card.implicitWidth,parent.width*0.6)
    height: Math.max(card.implicitHeight,parent.height*0.7)


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
        title: qsTr("Add Product")
        anchors.fill: parent;
        clip: true

        padding: 20
            GridLayout{
                anchors.fill: parent;

                rowSpacing: 20
                columnSpacing: 20

                flow: GridLayout.TopToBottom
                CTextFieldGroup{id: nameTF;        label.text: qsTr("Name");}
                CTextFieldGroup{id: descriptionTF; label.text: qsTr("Description");}
                CTextFieldGroup{id: barcodeTF;     label.text: qsTr("Barcode");       input.text:"";}
                CTextFieldGroup{id: listPriceTF;   label.text: qsTr("List Price");    input.text:"0"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
                CTextFieldGroup{id: costTF;        label.text: qsTr("Cost");          input.text:"0"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}

                CComboBoxGroup{
                    id: typeCB;
                    Layout.fillWidth: true
                    label.text: "Product Type"
                    comboBox.valueRole: "value"
                    comboBox.textRole: "modelData"

                    comboBox.model: ListModel {
                        ListElement { modelData: qsTr("Storable Product");   value: 1;}
                        ListElement { modelData: qsTr("Consumable Product"); value: 2;}
                        ListElement { modelData: qsTr("Service Product");    value: 3;}
                    }
                } //end typeCB

                CComboBoxGroup{
                    id: categoryCB
                    Layout.fillWidth: true
                    label.text: "Category"
                    comboBox.textRole: "category"
                    comboBox.valueRole: "id"
                    comboBox.currentIndex: 0;
                    comboBox.model: CategoriesModel{}
                } //end categoryCB


                CheckableComboBox{
                    Layout.fillWidth: true
                    //           Layout.maximumWidth: parent.width/2
                    model: TaxesCheckableModel{
                        id: taxesModel;
                    }
                    textRole: "name";
                    valueRole: "id"
                    displayText: taxesModel.selectedItems==="" ? qsTr("select Taxes...") : taxesModel.selectedItems;

                }



                ProductsModel{
                    id: model;

                    onProductAddReply: {
                        if(reply.status===200){
                            toastrService.push("Success",reply.message,"success",2000)
                            model.requestData();
                        }
                        else{
                            toastrService.push("Error",reply.message,"error",2000)
                        }
                    } //slot end
                }

            }



        function addProduct(){
            var name=nameTF.input.text;
            var type=typeCB.comboBox.currentValue;
            var cost=costTF.input.text;
            var listPrice=listPriceTF.input.text;
            var description=descriptionTF.input.text
            var barcode=barcodeTF.input.text;
            var categoryId=categoryCB.comboBox.currentValue;
            var selectedRowIds=taxesModel.selectedIds();
            var taxes=[];
            for(var i in selectedRowIds){
                taxes.push(taxesModel.data(i,"id"));
            }
            model.addProduct(name, barcode,listPrice, cost, type,description,categoryId,taxes,0);

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
                onClicked: card.addProduct();
            }

        } //footer end

    } //card End


}


