import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import app.models 1.0
import QtQml 2.15

ListView {
    id :listView
    clip: true
    property alias vendorCartModel: cartModel
    model: VendorCartModel{
        id: cartModel

        function addItem(){
            var product=productsModel.jsonObject(0);
            var record={
                "id" : product.id,
                "name" :product.name,
                "qty" : 1,
                "cost" : product.cost,
                "sku" : product.internal_sku,
                "thumb" : product.thumb,
                "total" : product.cost


            };
            cartModel.appendRecord(record);
            cartModel.refreshCartTotal();
        }
        function replaceData(index, product){
            //console.log(index)
            cartModel.setData(index,"id",product.id);
            cartModel.setData(index,"name",product.name);
            //cartModel.setData(index,"qty",1);
            cartModel.setData(index,"cost",product.cost)
            cartModel.setData(index,"sku","",product.internal_sku);
            cartModel.setData(index,"thumb",product.thumb);
            //cartModel.setData(index,"total",product.cost);
            //            console.log(cartModel.data(index,"cost"));

        }

    }
    spacing: 5
    //clip: true



    header: Rectangle{
        color: "white";
        anchors.horizontalCenter: parent.horizontalCenter
        z:2
        width: listView.width-10
        height: 80
        CButton{
            text: "Add Item"
            color: "#3399ff"
            textColor: "#FFFFFF"

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            onClicked: cartModel.addItem()
        }
    }

    ProductsModel{
        id: productsModel

        filter: {
            "type" : 1
        }

        onDataRecevied: {
            cartModel.addItem();
        }
        Component.onCompleted: requestData();
    }


    delegate: RowLayout{
        id: delegate
        implicitHeight: 50
        //        implicitWidth: 200
        width: listView.width-10

        spacing: 15


        CComboBox{
            id: cb
            Layout.preferredWidth: 500
            implicitWidth: 500
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.fillWidth: true
            textRole: "internal_sku"
            valueRole: "id"
            currentIndex: 0
            model: productsModel

            onCurrentIndexChanged:{
                //console.log("current index changed" + currentIndex)
                var product=productsModel.jsonObject(currentIndex)
                cartModel.replaceData(index,product);
            }

            contentItem: RowLayout{
                Image{
                    source: "https://"+model.thumb
                    sourceSize.height: parent.height*0.8

                    fillMode: Image.PreserveAspectFit
                    Layout.minimumWidth: 40

                }

                Text{
                    Layout.fillWidth: true
                    clip: true
                    text: cb.currentText
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                    rightPadding: 10
                }


            }

            delegate: ItemDelegate{
                text: model.internal_sku
                implicitWidth: cb.width
                icon.source: "https://"+model.thumb
                icon.color: "transparent"
                highlighted: cb.highlightedIndex === index
                font.bold: cb.currentIndex === index
                icon.height: 100
                icon.width: 60
                height: 100
            }

        }

        CTextField{
            Layout.topMargin: 10

            id: qty
            text: model.qty
            Layout.preferredWidth: 100
            placeholderText: "Quanitity..."
            validator: DoubleValidator{bottom: 0;top:1000000000}


            Binding{
                target: model
                property: "qty"
                value: parseInt(qty.text)
            }
            //onTextChanged: model.qty=parseInt(qty.text);


        }
        CTextField{
            Layout.topMargin: 10

            id: total;
            Layout.preferredWidth: 150
            text: Utils.formatCurrency(model.total)
            readOnly: true;
        }

        CButton{
            Layout.topMargin: 10

            color: "#e55353"
            textColor: "#ffffff"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            radius: height
            text: "X";

            onClicked: {
                cartModel.removeRecord(index);
                cartModel.refreshCartTotal();
            }
        }

    } //listview delegate end

    remove: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; to: 0; duration: 500 }
            NumberAnimation { properties: "y"; duration: 500 }
        }
    }

    removeDisplaced: Transition {
        NumberAnimation { properties: "y"; duration: 500 }
    }

    footer: Rectangle{
        color: "white";
        z:2
        width: listView.width-10
        height: 80
        anchors.horizontalCenter: parent.horizontalCenter
        CTextField{
            width: 300
            text: Utils.formatCurrency(cartModel.cartTotal)
            readOnly: true
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter


}
