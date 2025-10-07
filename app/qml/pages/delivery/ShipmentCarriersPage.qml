import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Drivers")
    delegate: AppDelegateChooser {}
    model: ShipmentCarriersModel{}
    basePath: "qrc:/PosFe/qml/pages/delivery";
    formFile: "ShipmentCarrierForm.qml"
    addPermission: "prm_add_shipment_carrier"
    editPermission: "prm_edit_shipment_carrier"
    deletePermission: "prm_remove_shipment_carrier"
    deletePath: "shipmentCarrier"
}
