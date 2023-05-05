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
    columns: 1
    CLabel {
        text: qsTr("Group Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
        Layout.fillWidth: true
        readOnly: initialValues
        enabled: !initialValues
    }

    CLabel {
        text: qsTr("Description")
    }
    CIconTextField {
        leftIcon.name: "cil-info"
        objectName: "description"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Permissions")
    }
    CheckableListView {
        id: view
        objectName: "acl_items"
        matchKey: "permission"
        implicitHeight: 400
        implicitWidth: 300
        Layout.fillWidth: true
        Layout.fillHeight: true

        section.property: "category"
        section.delegate: Label {
            padding: 10
            text: section
            font.bold: true
        }

        delegate: CheckableListView.CListViewCheckDelegate {
            text: model.permission
        }


        model: AclItemsModel {
            id: aclItemsModel
            checkable: true
//            onDataRecevied: page.updateChecked() //method has a flow if model is received before cb model
            sortKey: "category"
            direction: "desc"

            Component.onCompleted: requestData()
        }
    }




}
