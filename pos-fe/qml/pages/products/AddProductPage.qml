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
    title: qsTr("Add Product")


    GridLayout{
        anchors.margins: 10
        anchors.fill: parent;

//        anchors.rightMargin: parent.width*0.7
//        spacing: 20
        rowSpacing: 20
        columnSpacing: 20
//        columns: 2
        rows:8
        columns: 2

        flow: GridLayout.TopToBottom
        CTextFieldGroup{id: nameTF;        label.text: qsTr("Name");}
        CTextFieldGroup{id: descriptionTF; label.text: qsTr("Description");}
        CTextFieldGroup{id: barcodeTF;     label.text: qsTr("Barcode");       input.text:"0"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
        CTextFieldGroup{id: listPriceTF;   label.text: qsTr("List Price");    input.text:"0"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
        CTextFieldGroup{id: costTF;        label.text: qsTr("Cost");          input.text:"0"; input.validator: DoubleValidator{bottom: 0;top:1000000000}}

        CComboBoxGroup{
            id: typeCB;
            Layout.fillWidth: true
            label.text: "Product Type"
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
            comboBox.currentIndex: 0;
            comboBox.model: CategoriesModel{}
        } //end categoryCB

        CButton{
            text: qsTr("Add")
            color: "#2eb85c"
            textColor: "#ffffff"
            implicitHeight: 60
            Layout.margins: 10
            onClicked: parent.addProduct();
        }

        CheckableListView{
//            Layout.fillHeight: true
//            Layout.fillWidth: true


            Layout.minimumWidth: parent.width/2
            Layout.maximumWidth: parent.width/2
            Layout.fillHeight: true
//            Layout.minimumHeight: parent.height
//            Layout.maximumHeight: parent.height
            Layout.rowSpan: 4
//            Layout.preferredHeight: parent.height
//            list.model: CategoriesModel{

//            }

            list.model: TaxesCheckableModel{

            }
        }

        CheckableComboBox{
           Layout.fillWidth: true
           Layout.maximumWidth: parent.width/2

        }

        function addProduct(){
            var name=nameTF.input.text;
            var type=typeCB.comboBox.currentValue();
            var cost=costTF.input.text;
            var listPrice=listPriceTF.input.text;
            var description=descriptionTF.input.text
            var barcode=barcodeTF.input.text;
        }


    }



}
