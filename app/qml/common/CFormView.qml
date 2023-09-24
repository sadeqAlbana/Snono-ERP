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
AppPage{
    id: control
    default property alias content: grid.data
    property alias columns: grid.columns;
    property alias rows: grid.rows;
    property alias rowSpacing: grid.rowSpacing;
    property alias columnSpacing: grid.columnSpacing;
    property alias initialValues: form.initialValues
    property bool fillWidth: true
    property bool fillHeight: false
    property alias method : form.method
    property alias url : form.url
    property alias keyValue : form.keyValue
    property alias dataKey: form.dataKey; //query param key or json object key, default is id
    property alias applyHandler: form.applyHandler
    header.visible: false




    GridLayout {
        id: grid
        columns: 2

        anchors{
            left: control.fillWidth? parent.left : undefined
            right: control.fillWidth? parent.right : undefined
            top: control.fillHeight? parent.top : undefined
            bottom: control.fillHeight? parent.bottom : undefined


        }
    }

    CForm {
        id: form
        items: grid.children

    }

    footer: CDialogButtonBox{
        alignment: Qt.AlignRight | Qt.AlignVCenter
        position: DialogButtonBox.Footer
        spacing: 15
        onReset: form.setInitialValues();

        onApplied: {
            if(!form.validate()){
                return;
            }

            let handler=form.applyHandler;
            handler(form.data()).subscribe(function(reply){ //this stays like that until it becomes part of CoreUIQml
                        if(reply.status()===200){
                            Router.back();
                        }else{
                            console.log("error: "+ reply.status)
                        }
                    });
        }


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
            DialogButtonBox.buttonRole: DialogButtonBox.ApplyRole


        }

        CButton{
            text: qsTr("Cancel")
            palette: BrandDanger{}
            DialogButtonBox.buttonRole: DialogButtonBox.Cancel
            onClicked: Router.back();
        }

        CButton{
            text: qsTr("Reset")
            palette: BrandWarning{}
            DialogButtonBox.buttonRole: DialogButtonBox.ResetRole
        }

    }
}
