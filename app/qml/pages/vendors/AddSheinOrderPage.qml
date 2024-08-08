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
    url: "/sheinOrder"
    title: qsTr("Add Shein Order")
    columns: 2
    required property var orderManifest;

    Component.onCompleted: {
        NetworkManager.post("/shein/preview",{"data": orderManifest['order']}).subscribe(
                    function(res){
                    sheinModel.records=res.json('data');

                    })
    }

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

    CTableView {
        // objectName: "items"
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.minimumHeight: 400
        Layout.minimumWidth: 400
        Layout.columnSpan: 2
        delegate: AppDelegateChooser {}

        model: SheinOrderManifestModel {
            id: sheinModel
        }

    }
}


