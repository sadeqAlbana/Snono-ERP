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
    property var form;

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
        if(!form)
            return
        form.forEach(item => {
                         let label=Utils.createObject("qrc:/CoreUI/components/forms/CLabel.qml",layout);
                         label.text=item.label;
                         let options=item.options?? null

                                                    if(item.type==="text"){
                                                        delegate=Utils.createObject("qrc:/CoreUI/components/forms/CTextField.qml",layout,options);
                                                        delegate.Layout.fillWidth=true;
                                                        //delegate.placeholderText =item.label;
                                                    }
                         if(item.type==="combo"){
                             delegate=Utils.createObject("qrc:/common/CFilterComboBox.qml",layout,options);
                         }
                         if(item.type==="date"){
                             delegate=Utils.createObject("qrc:/CoreUI/components/forms/CDateInput.qml",layout,options);
                         }
                         delegate.Layout.fillWidth=true;
                         item.delegate=delegate
                     });

        let apply=Utils.createObject("qrc:/CoreUI/components/buttons/CButton.qml",layout);
        apply.Layout.fillWidth=true;
        apply.text=qsTr("Apply");
        apply.clicked.connect(function(){

            let filter={};
            form.forEach(item => {
                             if(item.type==="text"){
                                 if(item.delegate.text.length){
                                     filter[item.key]=item.delegate.text;
                                 }
                             }

                             if(item.type==="date"){
                                 if(item.delegate.acceptableInput)
                                    filter[item.key]=item.delegate.text;
                             }

                             if(item.type==="combo"){

                                 if(item.delegate.currentValue){
                                     filter[item.key]=item.delegate.currentValue;
                                 }

                             }
                         });

            //console.log(JSON.stringify(filter));
            popup.clicked(filter);

        });//clicked

        let reset=Utils.createObject("qrc:/CoreUI/components/buttons/CButton.qml",layout);
        reset.Layout.fillWidth=true;
        reset.text=qsTr("Reset");
        reset.palette=Utils.createObject("qrc:/CoreUI/palettes/BrandWarning.qml",reset)
        reset.clicked.connect(function(){


            form.forEach(item => {
                             if(item.type==="text"){
                                 item.delegate.clear();
                             }

                             if(item.type==="date"){
                                 if(item.delegate.acceptableInput)
                                 item.delegate.clearDate();
                             }

                             if(item.type==="combo"){
                                 item.delegate.currentIndex=0;

                             }
                         });


            popup.clicked({});

        });
    }
}
