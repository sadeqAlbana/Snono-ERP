import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

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
    basePath: "qrc:/PosFe/qml/pages/delivery";
    formFile: "ShipmentForm.qml"
    addPermission: "prm_add_shipment"
    editPermission: "prm_edit_shipment"
    deletePermission: "prm_remove_shipment"
    deletePath: "shipment"
}
