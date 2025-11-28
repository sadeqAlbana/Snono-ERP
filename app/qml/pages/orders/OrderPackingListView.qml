import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects
import PosFe
import JsonModels
ListView {
    id: listView

    clip: true
    required property int orderId
    Component.onCompleted: {
        NetworkManager.post("/order/packableItems", {"order_id":orderId}).subscribe(function (res) {
            if (res.json("status") === 200) {
                let order = res.json("order")
                var items = order.packable_items;
                // console.log(JSON.stringify(items));
                packingModel.setRecords(items)
                // packingModel.refreshReturnTotal()
            }
        });

    }

    model: OrderPackingModel {
        id: packingModel
    }

    spacing: 5

    header: RowLayout{

        CheckBox{
            id: checkCB;
            checkState: Qt.Unchecked;

            Connections{
                target: packingModel

                function onDataChanged(topLeft,bottomRight,roles){
                    checkCB.checkState=packingModel.checkState();
                }
            }


            onClicked: {
                if(checkState==Qt.Unchecked){
                    packingModel.uncheckAll()
                }else if(checkState==Qt.Checked || checkState==Qt.PartiallyChecked){
                    packingModel.checkAll()
                }
            }
        }

        CTextField{
            id: barcode
            placeholderText: qsTr("barcode...");

            onAccepted: {
                packingModel.add(text);
                text = ""
            }
        }
    }

    //clip: true
    delegate: RowLayout {
        id: delegate
        implicitHeight: 50
        //        implicitWidth: 200
        width: listView.width - 10

        spacing: 15

        Image{
            source: model.thumb
            fillMode: Image.PreserveAspectFit
            Layout.maximumHeight: 200
            opacity: model.checkState !==Qt.Unchecked? 1 : 0

        }

        ColumnLayout{
            CLabel {
                id: label
                text: model.name
                wrapMode: Text.WordWrap
                Layout.preferredWidth: 300
                enabled: model.checkState !==Qt.Unchecked
            }
            CLabel {
                id: sku
                text: model.sku
                wrapMode: Text.WordWrap
                Layout.preferredWidth: 300
                enabled: model.checkState !==Qt.Unchecked
            }
            CLabel {
                text: model.barcode
                wrapMode: Text.WordWrap
                Layout.preferredWidth: 300
                enabled: model.checkState !==Qt.Unchecked
            }
        }





        CLabel {
            Layout.topMargin: 10

            id: qty
            text: qsTr("required Quantity: ")+ model.qty
            font.bold: true

        }

        CSpinBox {
            Layout.topMargin: 10

            id: packedQty
            //text: model.qty
            value: model.packed_qty??0
            //Layout.preferredWidth: 100
            //placeholderText: "Quanitity..."
            from: 0
            to: {
                to = model.qty
            }
            enabled: model.checkState === Qt.Checked

            // Binding {
            //     target: model
            //     property: "packed_qty"
            //     value: packedQty.value
            // }
            //onTextChanged: model.qty=parseInt(qty.text);
        }
        // CTextField {
        //     Layout.topMargin: 10

        //     id: total
        //     Layout.preferredWidth: 150
        //     text: Utils.formatCurrency(model.total)
        //     readOnly: true
        //     enabled: model.checkState === Qt.Checked
        // }

        CheckBox {
            id: checkBox
            Layout.topMargin: 10
            checkState: model.checkState
            //color: "#e55353"
            //palette.buttonText: "#ffffff"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            onToggled: {
                model.checkState=checkState

            }
            // Binding {
            //     target: model
            //     property: "checkState"
            //     value: checkBox.checkState
            // }
            //radius: height
            //text: "X";

            //            onClicked: {
            //                cartModel.removeRecord(index);
            //                cartModel.refreshCartTotal();
            //            }
        }
    } //listview delegate end

    remove: Transition {
        ParallelAnimation {
            NumberAnimation {
                property: "opacity"
                to: 0
                duration: 500
            }
            NumberAnimation {
                properties: "y"
                duration: 500
            }
        }
    }

    removeDisplaced: Transition {
        NumberAnimation {
            properties: "y"
            duration: 500
        }
    }

    // footer: Rectangle {
    //     color: "white"
    //     z: 2
    //     width: listView.width
    //     height: 80
    //     //anchors.horizontalCenter: listView.horizontalCenter
    //     CTextField {
    //         width: 300

    //         //text: Utils.formatCurrency(cartModel.cartTotal)
    //         text: Utils.formatCurrency(packingModel.returnTotal)
    //         readOnly: true
    //         //anchors.verticalCenter: listView.verticalCenter
    //     }
    // }
    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter

    function returnedItems() {
        return packingModel.returnedLines()
    }
}

