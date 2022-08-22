import QtQuick
import QtQuick.Controls.Basic;
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils

ButtonPopup {
    id: popup
    signal clicked(var filter);
    property var form: [
        {"type": "text","label": "name","key": "name"},
        {"type": "combo","label": "product","key": "product_id",
            "options":{"defaultEntry":{"name":"All Products","id":null},"textRole": "name", "valueRole": "id","dataUrl": "/products/list",
                "filter":{"onlyVariants":true}}},
        {"type": "date","label": "from","key": "from"},
        {"type": "date","label": "to","key": "to"}

    ]
    property list<Item> delegs;

    Flickable{
        id: flickable
        clip: true
        implicitWidth: contentWidth
        implicitHeight: Math.min(contentHeight,400)
        anchors.fill: parent;
        contentWidth: layout.implicitWidth
        contentHeight: layout.implicitHeight
        flickableDirection: Flickable.VerticalFlick
        ColumnLayout{
            id: layout
            anchors.fill: parent;





        }//layout
    }//flickable






    Component.onCompleted: {

        let delegate=null;
        form.forEach(item => {

                         let label=Utils.createObject("qrc:/CoreUI/components/forms/CLabel.qml",layout);
                         label.text=item.label;
                         let options=item.options?? null

                         if(item.type==="text"){
                             delegate=Utils.createObject("qrc:/CoreUI/components/forms/CTextField.qml",layout,options);
                             delegate.Layout.fillWidth=true;
                             delegate.placeholderText =item.label
                         }
                         if(item.type==="combo"){
                             delegate=Utils.createObject("qrc:/common/CFilterComboBox.qml",layout,options);
                         }
                         if(item.type==="date"){
                             delegate=Utils.createObject("qrc:/CoreUI/components/forms/CDateInput.qml",layout,options);
                         }
                         delegate.Layout.fillWidth=true;
                         delegs.push(delegate);

                     });

        let apply=Utils.createObject("qrc:/CoreUI/components/buttons/CButton.qml",layout,{"id": "apply"});
        apply.Layout.fillWidth=true;
        apply.text=qsTr("Apply");
        apply.clicked.connect(function(){

            for(var i=0; i<delegs.length; i++){
                let child=delegs[i];
                if(child.id==="apply")
                    return;
                console.log(child.y)
            }


        });

    }
}
