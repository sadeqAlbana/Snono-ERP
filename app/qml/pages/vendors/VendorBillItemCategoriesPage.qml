import QtQuick
import QtQuick.Controls.Basic
import PosFe

CrudViewPage {
    id: page
    title: qsTr("Vendor bill Item Categories")
    delegate: AppDelegateChooser {}
    model: VendorBillItemCategoryModel{}
    basePath: "qrc:/PosFe/qml/pages/vendors";
    formFile: "VendorBillItemCategoryForm.qml"
    addPermission: "prm_add_vendor_bill_item_category"
    editPermission: "prm_eidt_vendor_bill_itemc_ategory"
    deletePermission: "prm_remove_vendor_bill_item_category"
    deletePath: "vendorBillItemCategory"
}



