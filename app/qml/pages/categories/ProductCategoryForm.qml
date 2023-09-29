import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    title: qsTr("Category")
    url: "/category"


    columns: 2
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-linear"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel{
        text: qsTr("Parent Category")
    }

    IconComboBox{
        Layout.fillWidth: true
        objectName: "parent_id"
        textRole: "category"
        valueRole: "id"
        currentIndex: 0;
        model: CategoriesModel{}
    } //end categoryCB
}
