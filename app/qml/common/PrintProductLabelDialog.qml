import QtQuick
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Views
import CoreUI.Forms
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import QtQuick.Layouts
import PosFe
Popup{
    id: dialog

    property var product: {"name":"","list_price":0}
    property int qty;

    modal: true
    parent: Overlay.overlay
    margins: 0
    padding: 0
    //width: parent.width
    //height: parent.height
    width: 500
    anchors.centerIn: parent;


    //closePolicy: Popup.NoAutoClose
    background: Rectangle{color: "transparent"}


    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }
    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Card{
        anchors.fill: parent;
        title: qsTr("Print Product Label")
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10
            CLabel{
                text: qsTr("Name: ") + product?.name
            }
            CLabel{
                text: qsTr("Price: ") +  Utils.formatCurrency(product.list_price)
            }

            CTextFieldGroup{id: quantity; label.text: qsTr("Quantity"); input.text:parseInt(1); input.validator: DoubleValidator{bottom: 0;top:100000}}
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
                text: qsTr("Print")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 60
                Layout.margins: 10
                onClicked: {


                    console.log(JSON.stringify(product))

                    let sku="";
                    let attributes=product.attributes;

                    attributes.forEach(attribute =>{
                                       if(attribute.attribute_id==="sku"){
                                               sku=attribute.value;
                                               return;
                                           }
                                       });

                    ReceiptGenerator.generateLabel(product.barcode, product.name,
                                                   Utils.formatCurrency(product.list_price),sku,
                                                   parseInt(quantity.input.text))

                }
            }


        }

    } //card end



}
