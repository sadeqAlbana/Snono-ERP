import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl

import CoreUI
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

CrudViewPage {
    id: page
    title: qsTr("Shipments")
    delegate: AppDelegateChooser {
                 DelegateChoice {
                     roleValue: "OrderStatus"
                     OrderStatusDelegate {}
                 }
                 DelegateChoice {
                     roleValue: "ShipmentStatus"
                     ShipmentStatusDelegate {}
                 }

                 DelegateChoice {
                     roleValue: "externalDeliveryStatus"
                     ExternalDeliveryStatusDelegate {}
                 }
             }
    model: ShipmentsModel{useNestedParentKeys:true;}

    actions: [
    CAction{
            text: qsTr("Settle")
            icon.name: "cil-plus"
            onTriggered: {

                Api.post("shipments/carriers/settlement/create", {"shipments_ids":[model.data(
                                     tableView.currentRow,
                                     "id")],
                             "status":"posted"}).subscribe(function (response) {
                                 if (response.json("status") === 200) {
                                     model.refresh()
                                 }
                             })

            }
        }

    ]
    basePath: "qrc:/PosFe/qml/pages/delivery";
    formFile: "ShipmentForm.qml"
    addPermission: "prm_add_shipment"
    editPermission: "prm_edit_shipment"
    deletePermission: "prm_remove_shipment"
    deletePath: "shipment"
}
