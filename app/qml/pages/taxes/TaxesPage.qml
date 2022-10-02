import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects

import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import PosFe
AppPage{

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

