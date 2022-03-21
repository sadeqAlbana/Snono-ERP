import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import App.Models 1.0
import "qrc:/common"
Card{
    title: qsTr("Vendors")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        anchors.margins: 20

        AppToolBar{
            id: toolBar
            tableView: tableView
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                Action{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: dialog.open();},
                Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeVendor()}

            ]


            AddVendorDialog{
                id: dialog;
                onAddVendor: model.addVendor(name,email,address,phone)
            }

            function removeVendor(){
                if(tableView.selectedRow>-1){
                    var vendorId= model.data(tableView.selectedRow,"id");
                    model.removeVendor(vendorId);                }
            }



            model: VendorsModel{
                id: model;

                onVendorAddReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end

                onVendorRemoveReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end


        } //model end

}

    }

    //Component.onCompleted: newBillDlg.open();
}



