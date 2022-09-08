import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/palettes"

CMenu {
    id: control
    property var model;
    signal clicked(var filter);

    implicitWidth: 300
    contentItem: ListView {
        id: listView
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
            width: listView.width
            bottomPadding: 8
        }


        delegate: DelegateChooser{
            role: "type"
            DelegateChoice {roleValue: "text"; CTextField {width: ListView.view.width}}
            DelegateChoice {roleValue: "combo"; CFilterComboBox {
                    dataUrl: modelData.options["dataUrl"]
                    editable: modelData.options["editable"];
                    valueRole: modelData.options["valueRole"]
                    textRole: modelData.options["textRole"]
                    defaultEntry: modelData.options["defaultEntry"]
                    filter: modelData.options["filter"]
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
            visible: listView.count
            width: ListView.view? ListView.view.width: 200
            CButton{
                Layout.topMargin: 15
                text: qsTr("Apply");
                palette: BrandSuccess{}
                Layout.fillWidth: true
                implicitHeight: 40

                onClicked: {
                    let filter={}
                    for(var i=0; i<listView.count; i++){
                        let data =listView.model[i]
                        let item=listView.itemAtIndex(i)
                        if(data.type==="text"){
                            if(item.text.length){
                                filter[data.key]=item.text;
                            }
                        }

                        if(data.type==="date"){
                            if(item.acceptableInput)
                               filter[data.key]=item.text;
                        }

                        if(data.type==="combo"){
                            if(item.currentValue){
                                filter[data.key]=item.currentValue;
                            }
                        }

                        if(data.type==="check"){
                            console.log("checked: " + item.checked)
                                filter[data.key]=item.checked
                        }

                    }//for loop

                    control.clicked(filter);

                }//onClicked
            }

            CButton{
                Layout.topMargin: 15
                text: qsTr("Reset");
                palette: BrandDanger{}
                Layout.fillWidth: true
                implicitHeight: 40

                onClicked: {
                    for(var i=0; i<listView.count; i++){
                        let data =listView.model[i]
                        let item=listView.itemAtIndex(i)
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
            }
        }

    }





}
