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
    title: qsTr("Carrier Settlements")
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
    basePath: "qrc:/PosFe/qml/pages/delivery";
    formFile: "CarrierSettlementForm.qml"
    addPermission: "prm_add_carrier_settlement"
    editPermission: ""
    deletePermission: "prm_remove_carrier_settlement"
    deletePath: "carriers/settlement"
}
