import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import CoreUI.Forms
import CoreUI.Impl
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Base
import CoreUI
Card{
    id: control
    default property alias content: grid.data
    property alias columns: grid.columns;
    property alias rows: grid.rows;
    property alias rowSpacing: grid.rowSpacing;
    property alias columnSpacing: grid.columnSpacing;
    property alias initialValues: form.initialValues
    property string method: "POST";
    property string url;
    required property var applyHandler;


    GridLayout {
        id: grid
        anchors.fill: parent
        columns: 2
    }

    CForm {
        id: form
        items: grid.children
        url: control.url
        applyHandler: control.applyHandler
        method: control.method

    }

    footer: CDialogButtonBox{
        alignment: Qt.AlignRight | Qt.AlignVCenter
        position: DialogButtonBox.Footer
        spacing: 15
        onReset: form.setInitialValues();
        onAccepted: form.apply();

        background: RoundedRect{
            radius: CoreUI.borderRadius
            border.color: palette.shadow
            topLeft: false
            topRight: false
            color: CoreUI.color(CoreUI.CardHeader)
            border.width: 1
        }
        CButton{
            text: qsTr("Apply")
            palette: BrandSuccess{}
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole


        }

        CButton{
            text: qsTr("Cancel")
            palette: BrandDanger{}
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
        }

        CButton{
            text: qsTr("Reset")
            palette: BrandWarning{}
            DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
        }

    }
}
