import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Equity Moves")
    delegate: AppDelegateChooser {}
    model: EquityMovesModel{}
    basePath: "qrc:/PosFe/qml/pages/equity";
    formFile: "OwnerDepositForm.qml"
    addPermission: "prm_add_equity_move"
    // editPermission: "prm_edit_owner"
    //deletePermission: "prm_remove_owner"
    // deletePath: "equity"
}
