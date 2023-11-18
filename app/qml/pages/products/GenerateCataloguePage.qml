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
    header.visible: true


    CLabel{text: qsTr("Start ID");}
    CNumberInput{objectName: "start_id"; text: "0";}
    CLabel{text: qsTr("Save Path");}
    FolderInput{objectName:"save_path"}
    CLabel{
        text: qsTr("Category")
    }

    CFilterComboBox{
        Layout.fillWidth: true
        objectName: "category_id"
        textRole: "name"
        valueRole: "id"
        dataUrl: "/categories"
        defaultEntry: {"id":-1,"name": qsTr("All")}
    } //
    applyHandler: Api.generateImages
}
