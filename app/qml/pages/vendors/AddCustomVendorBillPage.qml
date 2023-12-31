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
    header.visible: true
    url: "/vendorBill"
    title: qsTr("Add custom Vendor Bill")

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

    CustomVendorBillListView {
        objectName: "items"
        id: cartListView
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.columnSpan: 2
        model: CustomVendorCartModel {
            id: cartModel
        }
    }
}


// Card {
//     id: card
//     title: qsTr("New CustomBill")
//     padding: 10
//     ColumnLayout {
//         anchors.fill: parent

//         RowLayout {
//             Layout.fillWidth: true
//             Layout.fillHeight: true

//             CComboBox {
//                 id: vendorsCB
//                 Layout.fillWidth: true
//                 textRole: "name"
//                 valueRole: "id"
//                 currentIndex: 0
//                 model: VendorsModel {}
//             }

//             spacing: 30
//         }
//         spacing: 10


//     }

//     footer: RowLayout {

//         Rectangle {
//             color: "transparent"
//             Layout.fillWidth: true
//         }

//         CButton {
//             text: qsTr("Close")
//             palette.button: "#e55353"
//             palette.buttonText: "#ffffff"
//             implicitHeight: 50
//             Layout.margins: 10
//             onClicked: dialog.close()
//         }
//         CButton {
//             text: qsTr("Create")
//             palette.button: "#2eb85c"
//             palette.buttonText: "#ffffff"
//             implicitHeight: 50
//             Layout.margins: 10
//             onClicked: card.purchaseStock()
//         }
//     } //footer end

//     function purchaseStock() {
//         var vendor = vendorsCB.currentValue
//         var items = cartModel.toJsonArray()
//         var name = cartListView.billName
//         Api.processCustomBill(name, vendor, items).subscribe(function(res){
//             if(res.json('status')===200){
//                 Router.back();
//             }
//         });
//     }
// } //card End
