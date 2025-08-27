import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Payment Methods")
    delegate: AppDelegateChooser {

    }
    model: PaymentMethodModel{}
    basePath: "qrc:/PosFe/qml/pages/PaymentMethod";
    formFile: "PaymentMethodForm.qml"
    addPermission: "prm_add_payment_method"
    editPermission: "prm_edit_payment_method"
    deletePermission: "prm_remove_payment_method"
    deletePath: "paymentMethod"
}
