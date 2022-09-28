import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import QtQml 2.15
import QtQuick.Controls.impl as Impl

ListView {
    id :listView
    clip: false
    property string billName
    spacing: 5
    //clip: true

    function addItem(){
        //var product=productsModel.jsonObject(0);
        var record={
            //"id" : product.id,
            //"name" :product.name,
            "name": "",
            "qty" : 1,
            "cost" : 1000,
            //"sku" : product.sku,
            //"thumb" : product.thumb,
            "total" : 1000


        };
        model.appendRecord(record);
        //cartModel.refreshCartTotal();
    }

    header: RowLayout{
        z:2
        height: 80
        spacing: 20
        CTextField{
            id: name
            text: billName;
            implicitWidth: 250
            placeholderText: "Bill Name..."
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

            Binding{
                target: listView
                property: "billName"
                value: name.text;
            }

        }

        CButton{
            text: "Add Item"
            palette.button: "#3399ff"
            palette.buttonText: "#ffffff"
            Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
            onClicked: listView.addItem()
        }
    }



    delegate: RowLayout{
        id: delegate
        implicitHeight: 50
        //        implicitWidth: 200
        width: listView.width-10

        spacing: 15

        CTextField{
            id: itemName;
            Layout.fillWidth: true
            placeholderText: qsTr("item...")
        }

        CTextField{
            Layout.topMargin: 10

            id: cost;
            Layout.preferredWidth: 150
            placeholderText: "cost"
            text: model.cost
            Binding{
                target: model;
                property: "cost"
                value: parseInt(cost.text)
            }

            //readOnly: true;
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

            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            radius: height
            text: "X";

            onClicked: {
                listView.model.removeRecord(index);
                //cartModel.refreshCartTotal();
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
            text: Utils.formatCurrency(model.cartTotal)
            readOnly: true
            anchors.verticalCenter: parent.verticalCenter
        }

    }
    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter


}
