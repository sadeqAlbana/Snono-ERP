import QtQuick
import QtQuick.Controls.Basic
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
