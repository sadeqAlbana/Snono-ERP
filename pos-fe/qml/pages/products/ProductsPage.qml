import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.0
import Qt.labs.qmlmodels 1.0
import App.Models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

Card{
    title: qsTr("Products")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            tableView: tableView
            onSearch: {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }
        }
        ProductAddDialog{
            id: productAddDialog;

        }

        ProductEditDialog{
            id: editDlg
            onAccepted: {
                Api.updateProduct(editDlg.product)
                editDlg.close();
            }
        }

        Connections{
            target: Api

            function onUpdateProductReply(reply) {
                if(reply.status===200){
                    toastrService.push("Success",reply.message,"success",2000)
                    model.requestData();
                }
                else{
                    toastrService.push("Error",reply.message,"error",2000)
                }
            } //slot end
        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "image"; ImageDelegate{}}


            }

            actions: [
                Action{ text: qsTr("New"); icon.name: "cil-plus"; onTriggered: tableView.openAddDialog()},
                //Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeProduct()},
                Action{ text: qsTr("Edit"); icon.name: "cil-pen"; onTriggered: tableView.openEditDialog()},
                Action{ text: qsTr("Purchase Stock"); icon.name: "cil-cart"; onTriggered: tableView.openPurchaseDialog()}
            ]


            function openPurchaseDialog(){
                purchaseDialog.product=model.jsonObject(tableView.selectedRow);
                purchaseDialog.open();

            }
            function openEditDialog(){
                editDlg.product=model.jsonObject(tableView.selectedRow);
                editDlg.open();

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
                //filter: {"parent_id":0}
//                filter: {"only_variants":true}
//                filter: {}
                //onFilterChanged: console.log(JSON.stringify(filter))

                onProductRemoveReply: {
                    if(reply.status===200){
                        model.requestData();
                    }
                } //slot end

                onStockPurchasedReply: {
                    if(reply.status===200){
                        model.requestData();
                    }
                }

                Component.onCompleted: requestData();

            }//model

            function removeProduct(){
                var productId= model.data(tableView.selectedRow,"id");
                model.removeProduct(productId);
            }
        }
    }
}

