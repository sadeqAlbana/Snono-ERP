import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import PosFe
import CoreUI

CrudViewPage {
    id: page
    title: qsTr("Draft Orders")
    delegate: AppDelegateChooser {}
    model: DraftOrdersModel{}
    basePath: "qrc:/PosFe/qml/pages/orders";
    formFile: "DraftOrderForm.qml"
    addPermission: "prm_add_draft_orders"
    editPermission: "prm_edit_draft_orders"
    deletePermission: "prm_delete_draft_orders"
    deletePath: "draftOrder"
}
