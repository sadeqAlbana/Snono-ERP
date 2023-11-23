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
// Card{
//     id: card
//     title: qsTr("New Bill")

//     ColumnLayout{
//         anchors.fill: parent;
//         anchors.margins: 10

//     RowLayout{
//         Layout.fillWidth: true
//         Layout.fillHeight: true


//         CTextField{

//         }

//         CComboBox{
//             id: vendorsCB
//             Layout.fillWidth: true
//             textRole: "name"
//             valueRole: "id"
//             currentIndex: 0
//             model: VendorsModel{
//             }
//         }

//         spacing: 30

//     }
//         spacing: 10

//         VendorBillListView{
//             id: cartListView
//             Layout.fillHeight: true
//             Layout.fillWidth: true

//         }
//     }


//     footer: RowLayout{

//         Rectangle{
//             color: "transparent"
//             Layout.fillWidth: true

//         }

//         CButton{
//             text: qsTr("Close")
//             palette.button: "#e55353"
//             palette.buttonText: "#ffffff"
//             implicitHeight: 50
//             Layout.margins: 10
//             onClicked: dialog.close();


//         }
//         CButton{
//             text: qsTr("Purchase")
//             palette.button: "#2eb85c"
//             palette.buttonText: "#ffffff"
//             implicitHeight: 50
//             Layout.margins: 10
//             onClicked: card.purchaseStock();
//         }

//     } //footer end

//     function purchaseStock(){
//         var vendorId=vendorsCB.currentValue;
//         var products=cartListView.vendorCartModel.toJsonArray();
//         Api.createBill(vendorId,products);

//     }

// } //card End


CFormView {
    id: control
    padding: 10
    rowSpacing: 30

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
            ListElement{name: qsTr("Buy on Credit"); value: 0}
            ListElement{name: qsTr("Initial Inventory Purchase"); value: 1}
            ListElement{name: qsTr("Pay with a Liquidity Account"); value: 2}

        }
    }

    CLabel {
        text: qsTr("select account")
        visible: paymentTypeCB.currentValue===2
    }

    CFilterComboBox{
        objectName: "account_id";

        Layout.fillWidth: true
        dataUrl: "/accounts"
        filter:{"type":"liquidity"}
        textRole: "name";
        valueRole: "id"
        visible: paymentTypeCB.currentValue===2

    }

    VendorBillListView{
        id: cartListView
        objectName: "products"
        Layout.columnSpan: 2
        Layout.fillHeight: true
        Layout.fillWidth: true
    }
}

