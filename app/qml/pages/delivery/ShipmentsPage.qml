import QtQuick
import QtQuick.Controls.Basic
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

    advancedFilter: [
        {
            "type": "checkableCombo",
            "label": qsTr("Carrier"),
            "key": "carrier_ids",
            "dynamic": false,
            "category": null,
            "options": {
                "checkable": true,
                "editable": false,
                "textRole": "name",
                "valueRole": "id",
                "dataUrl": "/shipments/carriers"
            }
        },
        {
            "type": "checkableCombo",
            "label": qsTr("Driver"),
            "key": "driver_ids",
            "dynamic": false,
            "category": null,
            "options": {
                "checkable": true,
                "editable": false,
                "textRole": "first_name",
                "valueRole": "id",
                "dataUrl": "/driver/list"
            }
        }
    ]

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
    model: ShipmentsModel {
        useNestedParentKeys: true
    }

    actions: [
        CAction {
            text: qsTr("Settle")
            icon.name: "cil-plus"
            onTriggered: {

                Api.post("shipments/carriers/settlement/create", {
                             "shipments_ids": [model.recordAt(page.view.currentRow).id],
                         }).subscribe(function (response) {
                             if (response.json("status") === 200) {
                                 model.refresh()
                             }
                         })
            }
        }
    ]
    basePath: "qrc:/PosFe/qml/pages/delivery"
    formFile: "ShipmentForm.qml"
    addPermission: "prm_add_shipment"
    editPermission: "prm_edit_shipment"
    deletePermission: "prm_remove_shipment"
    deletePath: "shipment"
}
