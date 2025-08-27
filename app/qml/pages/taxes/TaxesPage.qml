import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Taxes")
    delegate: AppDelegateChooser {
        DelegateChoice {
            roleValue: "taxType"
            TaxTypeDelegate {}
        }
    }
    model: TaxesModel{}
    basePath: "qrc:/PosFe/qml/pages/taxes";
    formFile: "TaxForm.qml"
    addPermission: "prm_add_taxes"
    editPermission: "prm_edit_taxes"
    deletePermission: "prm_remove_taxes"
    deletePath: "tax"
}
