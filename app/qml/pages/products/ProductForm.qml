import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Buttons
import CoreUI.Palettes


CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    method: control.method
    url: control.url

    header.visible: true



//    CComboBoxGroup{
//        id: typeCB;
//        Layout.fillWidth: true
//        label.text: "Product Type"
//        comboBox.valueRole: "value"
//        comboBox.textRole: "modelData"

//        comboBox.model: ListModel {
//            ListElement { modelData: qsTr("Storable Product");   value: 1;}
//            ListElement { modelData: qsTr("Consumable Product"); value: 2;}
//            ListElement { modelData: qsTr("Service Product");    value: 3;}
//        }
//    } //end typeCB

//    CComboBoxGroup{
//        id: categoryCB
//        Layout.fillWidth: true
//        label.text: "Category"
//        comboBox.textRole: "category"
//        comboBox.valueRole: "id"
//        comboBox.currentIndex: 0;
//        comboBox.model: CategoriesModel{}
//    } //end categoryCB


//    CCheckableComboBox{
//        Layout.fillWidth: true
//        //           Layout.maximumWidth: parent.width/2
//        model: TaxesCheckableModel{
//            id: taxesModel;
//        }
//        textRole: "name";
//        valueRole: "id"
//        displayText: taxesModel.selectedItems==="" ? qsTr("select Taxes...") : taxesModel.selectedItems;

//    }


    columns: 4
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-pencil"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Description")
    }
    CIconTextField {
        leftIcon.name: "cil-description"
        objectName: "description"
        Layout.fillWidth: true

    }
    CLabel {
        text: qsTr("Barcode")
    }
    CIconTextField {
        leftIcon.name: "cil-barcode"
        objectName: "barcode"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("List Price")
    }
    CIconTextField {
        leftIcon.name: "cil-money"
        objectName: "list_price"
        Layout.fillWidth: true
    }
    CLabel {
        text: qsTr("Cost")
    }
    CIconTextField {
        leftIcon.name: "cil-money"
        objectName: "cost"
        Layout.fillWidth: true

    }


//    CLabel {
//        text: qsTr("Role")
//    }

//    IconComboBox {
//        id: cb
//        leftIcon.name: "cil-badge"
//        objectName: "acl_group_id"
//        valueRole: "id"
//        textRole: "name"
//        Layout.fillWidth: true


//        model: AclGroupsModel{
//            id: jsonModel
//            onDataRecevied: {
//                cb.model=jsonModel.toJsonArray();
//                if(initialValues){
//                    cb.currentIndex=cb.indexOfValue(initialValues[cb.objectName])

//                }
//            }
//        }
//    }
}
