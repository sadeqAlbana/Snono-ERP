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
    title: qsTr("Customers")
    delegate: AppDelegateChooser {}
    model: CustomersModel{}
    basePath: "qrc:/PosFe/qml/pages/customers";
    formFile: "CustomerForm.qml"
    addPermission: "prm_add_customers"
    editPermission: "prm_edit_customers"
    deletePermission: "prm_remove_customers"
    deletePath: "customer"
}
