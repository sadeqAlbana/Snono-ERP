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
    title: qsTr("Product Attributes")
    delegate: AppDelegateChooser {}
    model: ProductsAttributesAttributesModel{}
    basePath: "qrc:/PosFe/qml/pages/products";
    formFile: "ProductAttributeForm.qml"
    addPermission: "prm_edit_products_attribute"
    editPermission: "prm_edit_products_attributes"
    deletePermission: "prm_delete_products_attributes"
    deletePath: "productAttribute"
}
