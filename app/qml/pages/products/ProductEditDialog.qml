import QtQuick;import QtQuick.Controls.Basic;

import QtQuick.Layouts
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons


import Qt5Compat.GraphicalEffects
import App.Models 1.0
import PosFe
AppDialog{
    id: dialog
    parent: Overlay.overlay
    property var product: QtObject{
        property string name;
        property string barcode;
        property string description;
        property real list_price;
        property real cost;
        property var taxes:[] //this is the problem
    }

    onProductChanged: {
        taxesModel.uncheckAll();
        var ids=[];
        product.taxes.forEach(tax => {
                   ids.push(tax.id)
                              });
        taxesModel.setSelected(ids);
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
            CTextFieldGroup{id: nameTF; label.text: qsTr("Name"); input.text: product.name; }
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

//            CComboBox{
//                model: ProductsAttributesAttributesModel{
//                }
//                Layout.fillWidth: true
//                textRole: "name";
//                valueRole: "id"
////                displayText: taxesModel.selectedItems==="" ? qsTr("select Taxes...") : taxesModel.selectedItems;

//            }

//            ListView{
//             Layout.fillWidth: true
//             delegate: RowLayout{
//                 id: delegate
//                 implicitHeight: 50
//                 //        implicitWidth: 200
//                 width: listView.width-10
//                 spacing: 15

//             }
//            }

        } //grid end




        function updateProduct(){
            product.name=nameTF.input.text
            product.description=descriptionTF.input.text
            product.list_price=parseFloat(listPriceTF.input.text)
            product.cost=parseFloat(costTF.input.text)
            product.barcode=barcodeTF.input.text
            if(taxesModel.selectedIds().length){
                console.log("idst: " + taxesModel.selectedIds())
                product.taxes=taxesModel.selectedIds();
                console.log("ptaxes: " + product.taxes)

            }


        }

        footer: RowLayout{
            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                implicitWidth: 75

                text: qsTr("Close")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                implicitWidth: 75

                text: qsTr("Apply")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
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


