import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Locations")
    delegate: AppDelegateChooser {

    }
    model: LocationsModel{}
    basePath: "qrc:/PosFe/qml/pages/locations";
    formFile: "LocationForm.qml"
    addPermission: "prm_add_location"
    editPermission: "prm_edit_locations"
    deletePermission: "prm_remove_locations"
    deletePath: "location"
}
