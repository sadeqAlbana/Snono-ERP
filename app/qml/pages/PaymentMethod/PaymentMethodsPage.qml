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
