import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtGraphicalEffects 1.0
import app.models 1.0
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"
Card{

    title: qsTr("Products")

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
                id: search
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                font.pixelSize: 18
                placeholderText: qsTr("Search...")
                rightIcon: "qrc:/assets/icons/coreui/free/cil-search.svg"
                //rightIcon: "qrc:/assets/icons/coreui/free/cil-search.svg"


                onEntered: {
                    var filter=model.filter;
                    filter['barcode']=search.text
                    //filter['name']=search.text

                    model.setFilter(filter);
                    model.requestData();
                }
            }
        }


        ProductAddDialog{
            id: productAddDialog;

        }

        ProductEditDialog{
            id: editDlg


            onAccepted: {
                model.updateProduct(editDlg.product)
                editDlg.close();
                model.requestData();
            }

        }



        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{ roleValue: "image"; ImageDelegate{}}


            }

            actions: [
                Action{ text: qsTr("Add"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: tableView.openAddDialog()},
                Action{ text: qsTr("Delete"); icon.source: "qrc:/assets/icons/coreui/free/cil-delete.svg"; onTriggered: tableView.removeProduct()},
                Action{ text: qsTr("Edit"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: tableView.openEditDialog()},
                Action{ text: qsTr("Purchase Stock"); icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"; onTriggered: tableView.openPurchaseDialog()}
            ]


            function openPurchaseDialog(){
                purchaseDialog.product=model.jsonObject(tableView.selectedRow);
                purchaseDialog.open();

            }
            function openEditDialog(){
                editDlg.product=model.jsonObject(tableView.selectedRow);
                editDlg.open();

            }

            function updateProduct(product){

            }

            function openAddDialog(){
                productAddDialog.open();
            }

            PurchaseStockDialog{
                id: purchaseDialog

                onAccepted: {
                    var productId=model.data(tableView.selectedRow,"id");
                    model.purchaseStock(productId,quantity,vendorId);
                    purchaseDialog.close();
                }
            }

            model: ProductsModel{
                id: model
                Component.onCompleted: requestData();
                filter: {"parent_id":0}
                onProductUpdateReply: {
                    if(reply.status===200){
                        toastrService.push("Success",reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push("Error",reply.message,"error",2000)
                    }
                } //slot end

                onProductRemoveReply: {
                    if(reply.status===200){
                        toastrService.push(qsTr("Success"),reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push(qsTr("Error"),reply.message,"error",2000)
                    }
                } //slot end



                onStockPurchasedReply: {
                    if(reply.status===200){
                        toastrService.push(qsTr("Success"),reply.message,"success",2000)
                        model.requestData();
                    }
                    else{
                        toastrService.push(qsTr("Error"),reply.message,"error",2000)
                    }
                }
            }

            function removeProduct(){
                var productId= model.data(tableView.selectedRow,"id");
                model.removeProduct(productId);
            }
        }
    }
}

