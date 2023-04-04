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
Card{
    id: card
    title: qsTr("New Bill")

    Connections{
        target: Api
        function onAddCustomerReply(reply){
            if(reply.status===200){
                //toastrService.push("Success",reply.message,"success",2000)
                Router.back();
            }
        }
    }

    ColumnLayout{
        anchors.fill: parent;
        anchors.margins: 10

    RowLayout{
        Layout.fillWidth: true
        Layout.fillHeight: true

        CComboBox{
            id: vendorsCB
            Layout.fillWidth: true
            textRole: "name"
            valueRole: "id"
            currentIndex: 0
            model: VendorsModel{
                Component.onCompleted: requestData();
            }
        }

        spacing: 30

    }
        spacing: 10

        VendorBillListView{
            id: cartListView
            Layout.fillHeight: true
            Layout.fillWidth: true

        }
    }


    footer: RowLayout{

        Rectangle{
            color: "transparent"
            Layout.fillWidth: true

        }

        CButton{
            text: qsTr("Close")
            palette.button: "#e55353"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: dialog.close();


        }
        CButton{
            text: qsTr("Purchase")
            palette.button: "#2eb85c"
            palette.buttonText: "#ffffff"
            implicitHeight: 50
            Layout.margins: 10
            onClicked: card.purchaseStock();
        }

    } //footer end

    function purchaseStock(){
        var vendorId=vendorsCB.currentValue;
        var products=cartListView.vendorCartModel.toJsonArray();
        Api.createBill(vendorId,products);

    }

} //card End