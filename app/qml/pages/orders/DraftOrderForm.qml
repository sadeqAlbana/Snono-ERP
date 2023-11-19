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
Card {
    id: card
    title: qsTr("New Draft")
    padding: 10
    ColumnLayout {
        anchors.fill: parent

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            CComboBox {
                id: customersCB
                Layout.fillWidth: true
                textRole: "name"
                valueRole: "id"
                currentIndex: 0
                model: CustomersModel {}
            }

            spacing: 30
        }
        spacing: 10

        CustomVendorBillListView {
            id: cartListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: CustomVendorCartModel {
                id: cartModel
            }
        }
    }

    footer: RowLayout {

        Rectangle {
            color: "transparent"
            Layout.fillWidth: true
        }

        CButton {
            text: qsTr("Close")
            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: dialog.close()
        }
        CButton {
            text: qsTr("Create")
            palette.button: "#2eb85c"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: card.purchaseStock()
        }
    } //footer end

    function purchaseStock() {
        var vendor = vendorsCB.currentValue
        var items = cartModel.toJsonArray()
        var name = cartListView.billName
        Api.processCustomBill(name, vendor, items).subscribe(function(res){
            if(res.json('status')===200){
                Router.back();
            }
        });
    }
} //card End
