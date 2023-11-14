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
import CoreUI

import QtQml 2.15
import PosFe

ListView {
    id: listView
    clip: true
    property alias vendorCartModel: cartModel
    implicitWidth: contentWidth;
    implicitHeight: contentHeight

    Rectangle{
        parent: listView
        color: "transparent"
        border.color: palette.shadow
        radius: CoreUI.borderRadius
        anchors.fill: parent
    }

    model: VendorCartModel {
        id: cartModel

        function addItem() {
            var product = productsModel.jsonObject(0)
            var record = {
                "id": product.id,
                "name": product.name,
                "qty": 1,
                "cost": product.cost,
                "sku": product.sku,
                "thumb": product.thumb,
                "total": product.cost
            }
            cartModel.appendRecord(record)
            cartModel.refreshCartTotal()
        }
        function replaceData(index, product) {
            cartModel.setData(index, "id", product.id)
            cartModel.setData(index, "name", product.name)
            cartModel.setData(index, "cost", product.cost)
            cartModel.setData(index, "sku", "", product.sku)
            cartModel.setData(index, "thumb", product.thumb)
        }
    }
    spacing: 5

    //clip: true
    header: Rectangle {
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        z: 2
        width: listView.width - 10
        height: 80
        CButton {
            text: "Add Item"
            palette.button: "#3399ff"
            palette.buttonText: "#ffffff"

            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            onClicked: cartModel.addItem()
        }
    }

    ProductsModel {
        id: productsModel

        filter: {
            "type": 1
        }
    }

    delegate: RowLayout {
        id: delegate
        implicitHeight: 50
        width: listView.width - 10
        spacing: 15
        CComboBox {
            id: cb
            Layout.preferredWidth: 500
            implicitWidth: 500
            Layout.topMargin: 10
            Layout.leftMargin: 10
            Layout.fillWidth: true
            textRole: "name"
            valueRole: "id"
            currentIndex: 0
            model: productsModel
            onCurrentIndexChanged: {
                var product = productsModel.jsonObject(currentIndex)
                cartModel.replaceData(index, product)
            }
        }

        CTextField {
            id: qty
            Layout.topMargin: 10
            text: model.qty
            Layout.preferredWidth: 100
            placeholderText: "Quanitity..."
            validator: DoubleValidator {
                bottom: 0
                top: 1000000000
            }

            Binding {
                target: model
                property: "qty"
                value: parseInt(qty.text)
            }
            //onTextChanged: model.qty=parseInt(qty.text);
        }
        CTextField {
            id: total
            Layout.topMargin: 10
            Layout.preferredWidth: 150
            text: Utils.formatCurrency(model.total)
            readOnly: true
        }

        CButton {
            Layout.topMargin: 10
            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            Layout.preferredHeight: 40
            Layout.preferredWidth: 40
            radius: height
            text: "X"

            onClicked: {
                cartModel.removeRecord(index)
                cartModel.refreshCartTotal()
            }
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

    footer: Rectangle {
        color: "white"
        z: 2
        width: listView.width - 10
        height: 80
        anchors.horizontalCenter: parent.horizontalCenter
        CTextField {
            width: 300
            text: Utils.formatCurrency(cartModel.cartTotal)
            readOnly: true
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    headerPositioning: ListView.OverlayHeader
    footerPositioning: ListView.OverlayFooter
}
