import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import CoreUI.Forms
import CoreUI.Impl
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Menus
import CoreUI.Base
CMenu {
    id: control
    property var model;
    signal clicked(var filter);
    implicitWidth: 300
    contentItem: ListView {
        implicitHeight: contentHeight
        model: control.model
        interactive: Window.window
                     ? contentHeight + control.topPadding + control.bottomPadding > Window.window.height
                     : false
        clip: false

        section.property: "label"
        section.delegate: CLabel{
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: section
            width: ListView.view.width
            bottomPadding: 8
        }


        delegate: DelegateChooser{
            role: "type"
            DelegateChoice {roleValue: "text"; CTextField {width: ListView.view.width}}
            DelegateChoice {roleValue: "combo"; CFilterComboBox {
                    dataUrl: modelData.options["dataUrl"]?? ""
                    editable: modelData.options["editable"];
                    valueRole: modelData.options["valueRole"]
                    textRole: modelData.options["textRole"]
                    defaultEntry: modelData.options["defaultEntry"]
                    values: modelData.options["values"]?? null;
                    filter: modelData.options["filter"]
                    //checkable: modelData.options.checkable?? false
                    width: ListView.view.width
                    //Component.onCompleted: console.log("ttt: "+ JSON.stringify(modelData))
                }
            }
            DelegateChoice {roleValue: "date"; CDateInput {width: ListView.view.width}}

            DelegateChoice {roleValue: "check"; CheckBox {width: ListView.view.width;
                    text: modelData.inner_label ;checked: false;}}

        }

        currentIndex: control.currentIndex

        ScrollIndicator.vertical: ScrollIndicator {}

        footer: RowLayout{
            visible: ListView.view.count
            width: ListView.view? ListView.view.width: 200

            function apply(){
                let filter={};
                for(var i=0; i<ListView.view.count; i++){
                    let data =ListView.view.model[i]
                    let item=ListView.view.itemAtIndex(i)
                    let value=null;

                    if(data.type==="text"){
                        if(item.text.length){
                            value=item.text
                        }
                    }

                    if(data.type==="date"){
                        if(item.acceptableInput)
                            value=item.text
                    }

                    //use different delegate for checkable combo?
                    if(data.type==="combo"){

                        {
                            if(data.checkable){

                            }
                            else{
                                if(item.currentValue){
                                    value=[item.currentValue];
                                }
                            }
                        }


                    }

                    if(data.type==="check"){
                        value=item.checked
                    }

                    if(value){
                        if(data.category){
                            if(!filter.hasOwnProperty(data.category)){
                                filter[data.category]=Array()

                            }
                            let obj={"key": data.key, "value" : value};
                            filter[data.category].push(obj)
                        }
                        else{
                            filter[data.key]=value;
                        }

                    }//end if value


                }//for loop
                console.log(JSON.stringify(filter));

                control.clicked(filter);

            }//apply

            function reset(){
                for(var i=0; i<ListView.view.count; i++){
                    let data =ListView.view.model[i]
                    let item=ListView.view.itemAtIndex(i)
                    if(data.type==="text"){
                        item.clear();
                    }

                    if(data.type==="date"){
                        if(item.acceptableInput)
                            item.clearDate();
                    }


                    if(data.type==="combo"){
                        item.currentIndex=0;
                    }

                    if(data.type==="check"){
                        item.checked=false;
                    }
                }

                control.clicked({});
            }//clicked

            CButton{
                Layout.topMargin: 15
                text: qsTr("Apply");
                palette: BrandSuccess{}
                Layout.fillWidth: true
                implicitHeight: 40

                onClicked: apply();
            }

            CButton{
                Layout.topMargin: 15
                text: qsTr("Reset");
                palette: BrandDanger{}
                Layout.fillWidth: true
                implicitHeight: 40

                onClicked: reset();
            }
        }

    }
}