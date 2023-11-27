import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils


CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    title: qsTr("Add Vendor Bill")

    header.visible: true
    url: "/product/purchaseProduct"


    columns: 2
    CLabel {
        text: qsTr("Vendor")
    }

    CFilterComboBox {
        id: cb
        objectName: "vendor_id"
        valueRole: "id"
        textRole: "name"
        Layout.fillWidth: true
        dataUrl: "/vendors"
    }

    CLabel {
        text: qsTr("Bill Name")
    }
    CTextField {
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("External Reference")
    }
    CTextField {
        objectName: "external_reference"
        Layout.fillWidth: true
    }


    CLabel {
        text: qsTr("payment type")
    }

    CComboBox{
        objectName: "payment_type"
        id: paymentTypeCB
        Layout.fillWidth: true
        textRole: "name";
        valueRole: "value"
        model:ListModel{
            ListElement{name: qsTr("Buy on Credit"); value: "credit"}
            ListElement{name: qsTr("Initial Inventory Purchase"); value: "capital"}
            ListElement{name: qsTr("Pay with a Liquidity Account"); value: "liquidity"}
        }
    }

    CLabel {
        text: qsTr("select account")
        visible: paymentTypeCB.currentValue==="liquidity"
    }

    CFilterComboBox{
        objectName: "account_id";
        Layout.fillWidth: true
        dataUrl: "/accounts"
        filter:{"type":"liquidity"}
        textRole: "name";
        valueRole: "id"
        visible: paymentTypeCB.currentValue==="liquidity"

    }

    VendorBillListView{
        id: cartListView
        objectName: "products"
        Layout.columnSpan: 2
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}

