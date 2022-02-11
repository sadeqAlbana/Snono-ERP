import QtQuick 2.15

import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/common"

import QtGraphicalEffects 1.0
import app.models 1.0

AppDialog{
    id: dialog
    parent: Overlay.overlay
    property var product: QtObject{
        property string name;
        property string barcode;
        property string description;
        property real list_price;
        property real cost;
    }
    signal accepted();

    width:  Math.max(card.implicitWidth,parent.width*0.6)
    height: Math.max(card.implicitHeight,parent.height*0.7)

    Card{
        id: card
        title: qsTr("Edit Product")
       anchors.fill: parent
       padding: 20


        ColumnLayout{
            id: layout
            anchors.fill: parent
            CTextFieldGroup{id: nameTF;        label.text: qsTr("Name"); input.text: product.name;}
            CTextFieldGroup{id: barcodeTF; label.text: qsTr("Barcode");   input.text: product.barcode;}

            CTextFieldGroup{id: descriptionTF; label.text: qsTr("Description");   input.text: product.description;}
            CTextFieldGroup{id: listPriceTF;   label.text: qsTr("List Price");    input.text:product.list_price; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
            CTextFieldGroup{id: costTF;        label.text: qsTr("Cost");          input.text:product.cost; input.validator: DoubleValidator{bottom: 0;top:1000000000}}
            CheckableComboBox{
                model: TaxesCheckableModel{
                    id: taxesModel;
                }
                Layout.fillWidth: true
                textRole: "name";
                valueRole: "id"
                displayText: taxesModel.selectedItems==="" ? qsTr("select Taxes...") : taxesModel.selectedItems;

            }

        } //grid end




        function updateProduct(){
            product.name=nameTF.input.text
            product.description=descriptionTF.input.text
            product.list_price=parseFloat(listPriceTF.input.text)
            product.cost=parseFloat(costTF.input.text)
            product.barcode=barcodeTF.input.text

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
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Apply")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: {card.updateProduct(); accepted(); dialog.close();}

            }

        } //footer end

    } //card End


    //    onClosed: {
    //        destroy(1000)
    //    }
}


