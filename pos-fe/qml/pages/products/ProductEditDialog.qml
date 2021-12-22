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
    property var product: QtObject{
    property string name;
        property string barcode;
        property string description;
        property real list_price;
        property real cost;
    }
    signal accepted();

    width: parent.width*0.6
    height: parent.height*0.8
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
        title: qsTr("Edit Product")
        anchors.fill: parent;

        GridLayout{
            anchors.margins: 10
            anchors.fill: parent;

            //        anchors.rightMargin: parent.width*0.7
            //        spacing: 20
            rowSpacing: 20
            columnSpacing: 20
            //        columns: 2
            //rows:8

            flow: GridLayout.TopToBottom
            CTextFieldGroup{id: nameTF;        label.text: qsTr("Name"); input.text: product.name;}
            CTextFieldGroup{id: barcodeTF; label.text: qsTr("Barcode"); input.readOnly: true;   input.text: product.barcode;}

            CTextFieldGroup{id: descriptionTF; label.text: qsTr("Description");   input.text: product.description;}
            CTextFieldGroup{id: listPriceTF;   label.text: qsTr("List Price");    input.text:product.list_price; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
            CTextFieldGroup{id: costTF;        label.text: qsTr("Cost");          input.text:product.cost; input.validator: DoubleValidator{bottom: 0;top:1000000000}}


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







        }

        function updateProduct(){
            product.name=nameTF.input.text
            product.description=descriptionTF.input.text

            product.list_price=parseFloat(listPriceTF.input.text)
            product.cost=parseFloat(costTF.input.text)

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
                text: qsTr("Apply")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: {card.updateProduct(); accepted(); dialog.close();}
            }

        } //footer end

    } //card End


//    onClosed: {
//        destroy(1000)
//    }
}


