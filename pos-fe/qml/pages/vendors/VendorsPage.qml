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
import app.models 1.0

Card{

    title: qsTr("Vendors")

    ColumnLayout{
        id: page
        anchors.fill: parent;
        anchors.margins: 20
        RowLayout{
            spacing: 15

            CMenuBar{
                CMenu{
                    title: qsTr("Actions");
                    icon:"qrc:/assets/icons/coreui/free/cil-settings.svg"
                    actions: tableView.actions
                }
            }

            Rectangle{
                Layout.fillWidth: true
                color: "transparent"
            }

            CTextField{
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
                placeholderText: qsTr("Search...")
                rightIcon: "qrc:/assets/icons/coreui/free/cil-search.svg"
            }
        }

        PurchaseStockDialog{
            id: newBillDlg
        }


        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                Action{ text: qsTr("Add"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: dialog.open();},
                Action{ text: "Delete"; icon.source: "qrc:/assets/icons/coreui/free/cil-delete.svg"; onTriggered: tableView.removeVendor()},
                Action{ text: qsTr("New Bill"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: newBillDlg.open();}

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

    Component.onCompleted: newBillDlg.open();
}



