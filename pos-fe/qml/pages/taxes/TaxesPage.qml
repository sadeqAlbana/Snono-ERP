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

    title: qsTr("Taxes")
    padding: 15
    ColumnLayout{
        id: page
        anchors.fill: parent;

        AppToolBar{
            id: toolBar
            tableView: tableView
        }





        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "taxType"; TaxTypeDelegate{}}


            }

            actions: [
                Action{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: tableView.openAddDialog()},
                Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: tableView.removeProduct()}
            ]








            model: TaxesModel{
                id: model

//                onProductRemoveReply: {
//                    if(reply.status===200){
//                        toastrService.push(qsTr("Success"),reply.message,"success",2000)
//                        model.requestData();
//                    }
//                    else{
//                        toastrService.push(qsTr("Error"),reply.message,"error",2000)
//                    }
//                } //slot end



//                onStockPurchasedReply: {
//                    if(reply.status===200){
//                        toastrService.push(qsTr("Success"),reply.message,"success",2000)
//                        model.requestData();
//                    }
//                    else{
//                        toastrService.push(qsTr("Error"),reply.message,"error",2000)
//                    }
//                }
            }

//            function removeProduct(){
//                var productId= model.data(tableView.selectedRow,"id");
//                model.removeProduct(productId);
//            }
        }
    }
}

