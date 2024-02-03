import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
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
}
