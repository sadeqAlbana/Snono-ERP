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
    title: qsTr("Vendors")
    delegate: AppDelegateChooser {}
    model: VendorsModel{}
    basePath: "qrc:/PosFe/qml/pages/vendors";
    formFile: "VendorForm.qml"
    addPermission: "prm_add_vendors"
    editPermission: "prm_edit_vendors"
    deletePermission: "prm_remove_vendors"
    deletePath: "vendor"
}
