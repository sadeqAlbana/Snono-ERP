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
import PosFe
import JsonModels
import CoreUI
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
    header: Rectangle{
        color: "white";
        implicitHeight: 80
        implicitWidth: listView.width
        z: 3
        RowLayout{
            anchors.left: parent.left
            height: parent.height
            CheckBox{
                id: checkCB;
                checkState: Qt.Unchecked;
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
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
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter

                placeholderText: qsTr("barcode...");

                onAccepted: {
                    packingModel.add(text);
                    text = ""
                }

                Component.onCompleted: forceActiveFocus();
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
            opacity: model.checkState !==Qt.Unchecked? 1 : 0.5

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
            value: model.packed_qty
            from: 0
            to: model.qty


            onValueChanged: {
                if(model.packed_qty!==value){
                    model.packed_qty=value;

                }

            }

            // Binding {
            //     target: model
            //     property: "packed_qty"
            //     value: packedQty.value
            // }
        }


        CheckBox {
            id: checkBox
            Layout.topMargin: 10
            checkState: model.checkState
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            onToggled: {
                model.checkState=checkState

            }

        }
    } //listview delegate end
    footer: Rectangle{
        color: "white";
        implicitHeight: 80
        implicitWidth: listView.width
        z: 3

        RowLayout {

            Rectangle {
                color: "transparent"
                Layout.fillWidth: true
            }

            CButton {
                text: qsTr("Back")
                palette.button: "#e55353"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: Router.back();
            }
            CButton {
                id: packButton
                text: qsTr("Pack")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                enabled: false

                Connections{
                    target: packingModel

                    function onDataChanged(topLeft,bottomRight,roles){
                        packButton.enabled=packingModel.checkState()===Qt.Checked
                    }
                }

                onClicked: {
                    NetworkManager.post('/order/fulfill', {
                                            "order_id": orderId,
                                            "packed_items": packingModel.records
                                        }).subscribe(function (response) {

                                            if (response.json(
                                                        'status') === 200) {
                                                Router.back();
                                            }
                                        })
                }
            }
        }

    } //footer end



    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter

    function returnedItems() {
        return packingModel.returnedLines()
    }
}

