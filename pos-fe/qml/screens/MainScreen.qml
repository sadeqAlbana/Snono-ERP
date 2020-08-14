import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQml.Models 2.12
Item {
    id: rootItem



    ToolBar{
        id: toolBar;
        y:0
        width:drawer.opened ? rootItem.width-drawer.width : rootItem.width
        //        x: rootItem.width-drawer.width
        x: drawer.opened ? drawer.width  : 0
        height: 56
        background: Rectangle{

            color: "white"
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                Layout.leftMargin: 20
                id : toggleButton
                text: qsTr("☰")
                contentItem: Text{
                    color: "#7f7f8a"
                    text: toggleButton.text
                    font.pointSize: 15
                }

                onClicked: drawer.opened ? drawer.close() : drawer.open();
                background: Rectangle{
                    color: "white"
                }

            }

            Label {
                text: "Title"
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "#7f7f8a"
            }
            ToolButton {
                text: qsTr("‹")
                //onClicked: stack.pop()
                background: Rectangle{
                    color: "white"
                }
            }
        }

        Rectangle{
            anchors.fill: parent;
            border.color: "#d8dbe0"
            color: "transparent"
        }


    }

    Drawer{
        id: drawer

        width: 256

        height: rootItem.height
        dim:false
        closePolicy: Popup.NoAutoClose //this causes a problem in closing
        visible: true

        background: Rectangle{
            //color: "#29363d"
            color: "#3c4b64"
        }


        ListView{
            id: listView
            anchors.fill: parent;
            interactive: true
            property real delegateHeight: 0
            header : Rectangle{
                //color: drawer.background.color
                color: "#303c54"
                width: parent.width
                height: toolBar.height
                Image{
                    id: image
                    anchors.centerIn: parent;
                    source:"qrc:/icons/coreui/brand/cib-coreui.svg"
                    sourceSize.width: 82
                    sourceSize.height: 82
                    ColorOverlay{
                        anchors.fill: image
                        source:image
                        color:"white"

                    }
                }
            }

            footer : Rectangle{
                color: "#303c54"
                width: parent.width
                height: toolBar.height

                Label{
                    id: footerLabel
                    anchors.right: parent.right
                    anchors.rightMargin: 13
                    anchors.verticalCenter: parent.verticalCenter
                    text: "‹"
                    //font.bold: true
                    font.pointSize: 30
                    color: "#7f7f8a"
                }




                MouseArea{ //cursor  flickers when pointing at label !
                    anchors.fill: parent;
                    onContainsMouseChanged: {
                        color= containsMouse ? "#2a3446" :   "#303c54";
                        footerLabel.color= containsMouse ? "white" :   "#7f7f8a";
                    }
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                }
            }

            footerPositioning: ListView.OverlayFooter



            delegate: ItemDelegate{
                id: control

                MouseArea{
                    anchors.fill: parent;
                    onPressed:  mouse.accepted = false
                    cursorShape: Qt.PointingHandCursor

                }

                width: parent.width;
                height: 48.33
                hoverEnabled: true
                highlighted: ListView.isCurrentItem

                //: "normal"
                contentItem: RowLayout{
                    anchors.fill: parent
                    Image{
                        id: itemImage
                        source: model.image ? model.image : source
                        sourceSize.width: 17
                        sourceSize.height: 17
                        width: 17
                        height: 17
                        //                        width: 56
                        //                        height: 17.5
                        Layout.alignment: Qt.AlignVCenter
                        Layout.leftMargin: 13
                        ColorOverlay{
                            id: overlay
                            anchors.fill: itemImage
                            source:itemImage
                            color:"#afb5c0"
                        }

                    }
                    Label{
                        id:  itemText
                        text:model.title
                        color : "#afb5c0"
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        horizontalAlignment: Qt.AlignLeft
                        verticalAlignment: Qt.AlignVCenter
                        Layout.leftMargin: 10
                        font.family: "-apple-system,BlinkMacSystemFont,segoe ui,Roboto,helvetica neue,Arial,noto sans,sans-serif,apple color emoji,segoe ui emoji,segoe ui symbol,noto color emoji"
                        font.bold: false
                        font.pixelSize: 14
                    }

                    Label{
                        id: treeLabel



                        visible: model.childItems ? true : false
                        Layout.alignment: Qt.AlignRight
                        Layout.rightMargin: 13
                        text: "‹"
                        font.pointSize: 13
                        color: "#7f7f8a"
                        smooth: true

                        states:
                            State{
                            name: "toggled"
                            PropertyChanges {target: treeLabel; rotation: -90}
                        }

                        transitions: Transition {
                            RotationAnimation { duration: 150; direction: RotationAnimation.Shortest }
                        }

                    }

                }

                states: [
                    State{
                        name: "hovered"
                        when: control.hovered
                        PropertyChanges {target: controlBackground; color: "#321fdb"}
                        PropertyChanges {target: itemText; color: "white"}
                        PropertyChanges {target: overlay; color: "white"}
                        PropertyChanges {target: treeLabel; color: "white"}
                        PropertyChanges {target: treeLabel; font.bold: true}
                    },
                    State{
                        name: "highlighted"
                        when: control.highlighted
                        PropertyChanges {target: controlBackground; color: "#46546c" }
                        PropertyChanges {target: itemText; color: "white"}
                        PropertyChanges {target: overlay; color: "white"}


                    }
                ]





                background: Rectangle{
                    id: controlBackground
                    opacity: enabled ? 1 : 0.3
                    color: drawer.background.color
                }



                onClicked: {

                    if (listView.currentIndex !== index) {
                        listView.currentIndex = index
                    }

                    if(model.childItems){
                        if(treeLabel.state=="toggled"){
                            treeLabel.state="";
                            listModel.remove(listView.currentIndex+1,model.childCount);
                        }else{
                            treeLabel.state="toggled";
                            var childItems=JSON.parse(model.childItems);
                            for(var i=0; i <childItems.length; i++){
                                var item=childItems[i];
                                item.category=model.category;
                                listModel.insert(listView.currentIndex+1+i,item);
                            }
                        }
                    }
                }

            }

            model: ListModel{
                id: listModel;
                dynamicRoles: true
//                ListElement {title:  "Dashboard"; image: "qrc:/icons/coreui/free/cil-speedometer.svg";}
//                ListElement {title:  "Colors"; image: "qrc:/icons/coreui/free/cil-drop.svg";  category:  "THEME"; }
//                ListElement {title:  "Typography"; image: "qrc:/icons/coreui/free/cil-pen.svg";  category:  "THEME"}

//                ListElement {title:  "Base"; image: "qrc:/icons/coreui/free/cil-puzzle.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Buttons"; image: "qrc:/icons/coreui/free/cil-cursor.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Charts"; image: "qrc:/icons/coreui/free/cil-chart-pie.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Editors"; image: "qrc:/icons/coreui/free/cil-code.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Forms"; image: "qrc:/icons/coreui/free/cil-notes.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Google Maps"; image: "qrc:/icons/coreui/free/cil-map.svg";  category:  "COMPONENTS";}
//                ListElement {title:  "Icons"; image: "qrc:/icons/coreui/free/cil-star.svg";  category:  "COMPONENTS";}
            }

            section.property: "category"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle{
                id: sectionHeading
                width: parent.width
                height: 52.33
                color: drawer.background.color;
                Label {
                    text: section
                    font.bold: true
                    font.pixelSize: 10
                    anchors.left:parent.left
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                    anchors.leftMargin: 13
                    color: "#d4d7dd"
                }
            }
        }
    }

    Rectangle{
        y: toolBar.height
        width:drawer.opened ? rootItem.width-drawer.width : rootItem.width
        x: drawer.opened ? drawer.width  : 0
        height: rootItem.height-toolBar.height
        color: "#ebedef"
    }

    Component.onCompleted: {

        var listItems=[
                {
                 "title":  "Dashboard",
                 "category":"",
                 "image": "qrc:/icons/coreui/free/cil-speedometer.svg",
                 "path" : ""
                 },
                    {
                     "title":  "Colors",
                     "category":"THEME",
                     "image": "qrc:/icons/coreui/free/cil-drop.svg",
                     "path" : "",
                     //"children" : null
                     },
                    {
                     "title":  "Typography",
                     "category":"THEME",
                     "image": "qrc:/icons/coreui/free/cil-pen.svg",
                     "path" : "",
                     //"children" : null
                     },

                    {
                     "title":  "Base",
                     "category":"COMPONENTS",
                     "image": "qrc:/icons/coreui/free/cil-pen.svg",
                     "path" : "",
                     "childItems" : [
                            {
                             "title":  "Breadcrumb",
                             "path" : "",
                             },
                            {
                                "title":  "Cards",
                                "path" : "",
                             }
                        ]
                     },


                    {
                        "title":  "Buttons",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-cursor.svg",
                        "path" : "",
                        //"children" : null

                    }

                ];

//qrc:/icons/coreui/free/cil-cursor.svg
        //console.log(JSON.stringify(listItems));
        //console.log(JSON.stringify(listItems[3].childItems))
        for(var i=0; i<listItems.length; i++){

            var item=listItems[i];
            if(item.childItems){
                item.childCount=item.childItems.length;
                //console.log(item.childCount);
                item.childItems=JSON.stringify(item.childItems);
            }

            listModel.append(item);
        }
    }

}
