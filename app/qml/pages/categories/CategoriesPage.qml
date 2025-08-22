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
    title: qsTr("Categories")
    delegate: AppDelegateChooser {}
    model: CategoriesModel{}
    basePath: "qrc:/PosFe/qml/pages/categories";
    formFile: "ProductCategoryForm.qml"
    addPermission: "prm_add_category"
    editPermission: "prm_edit_categories"
    deletePermission: "prm_remove_categories"
    deletePath: "category"
}



