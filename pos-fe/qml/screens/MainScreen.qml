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
                clip:true
                property bool expanded: model.expanded ? model.expanded : false
                property bool hidden: model.parentId ? model.hidden : false
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
                transitions:[
                    Transition {
//                        from: "hidden"
//                        to: ""
                        reversible: true
                        SequentialAnimation {
                            PropertyAnimation { property: "height"; duration: 150 }
                        }
                    }
                ]


                states: [

                    State{

                        name: "visibleChild";
                        when: model.parentId && !model.hidden && !hovered && !highlighted;
                        PropertyChanges {target: controlBackground; color: "#303c50"}
                    },

                    State{
                        id:expandedHovered
                        name: "expandedHovered";
                        when: expanded && hovered;
                        extend: "hovered";
                        PropertyChanges {target: treeLabel; state: "toggled";}
                    },
                    State{
                        id:stateHidden
                        name: "hidden";
                        when: hidden
                        PropertyChanges {target: control; height:0;}
                    },

                    State{
                        id:stateExpanded
                        name: "expanded";
                        when: control.expanded;
                        PropertyChanges {target: treeLabel; state: "toggled";}
                        PropertyChanges {target: controlBackground; color: "#303c50"}
                    },
                    State{
                        id: stateHovered;
                        name: "hovered"
                        when: control.hovered
                        PropertyChanges {target: controlBackground; color: "#321fdb"}
                        PropertyChanges {target: itemText; color: "white"}
                        PropertyChanges {target: overlay; color: "white"}
                        PropertyChanges {target: treeLabel; color: "white"}
                        PropertyChanges {target: treeLabel; font.bold: true}
                    },
                    State{
                        id:stateHighlighted
                        name: "highlighted"
                        when: control.highlighted
                        PropertyChanges {target: controlBackground; color: "#46546c" }
                        PropertyChanges {target: itemText; color: "white"}
                        PropertyChanges {target: overlay; color: "white"}
                        //PropertyChanges {target: treeLabel; state: "toggled";}
                    }

                ]


                background: Rectangle{
                    id: controlBackground
                    opacity: enabled ? 1 : 0.3
                    color: drawer.background.color
                }


                onClicked: {
                    if (listView.currentIndex !== index && !model.childCount) {
                        listView.currentIndex = index
                        //shrink other items;



                    }
                    if(model.childCount){
                        model.expanded=!model.expanded;
                    }

                    //shrink other items;

                    for(var i=0; i<listModel.count;i++){

                        if(i!==index && i!==model.parentId){
                            listModel.get(i).expanded=false;
                        }
                    }




                }



                onExpandedChanged: {
                    for(var i=0; i<model.childCount;i++){
                        listModel.get(index+1+i).hidden=!expanded
                    }
                }

            }

            model: ListModel{
                id: listModel;
                dynamicRoles: false
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
                        "path" : ""
                    },
                    {
                        "title":  "Typography",
                        "category":"THEME",
                        "image": "qrc:/icons/coreui/free/cil-pen.svg",
                        "path" : ""
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
                        "childItems" : [
                            {
                                "title":  "Buttons",
                                "path" : "",
                            }

                        ]

                    },
                    {
                        "title":  "Charts",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-chart-pie.svg",
                        "path" : "",
                        //"children" : null

                    },
                    {
                        "title":  "Editors",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-code.svg",
                        "path" : "",
                        //"children" : null

                    },
                    {
                        "title":  "Forms",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-notes.svg",
                        "path" : "",
                        //"children" : null

                    },
                    {
                        "title":  "Google Maps",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-map.svg",
                        "path" : "",
                        //"children" : null

                    },
                    {
                        "title":  "Icons",
                        "category":"COMPONENTS",
                        "image": "qrc:/icons/coreui/free/cil-star.svg",
                        "path" : "",
                        //"children" : null

                    },

                ];




        for(var i=0; i<listItems.length; i++){
            var item=listItems[i];
            item.id=listModel.count;
            if(item.childItems){

                item.childCount=item.childItems.length;
                item.expanded=false;
                listModel.append(item);
                for(var j=0; j<item.childItems.length; j++){
                    var child=item.childItems[j];
                    child.id=listModel.count
                    child.parentId=item.id
                    child.hidden=true;
                    child.category=item.category;
                    //console.log(child)
                    listModel.append(child);
                }
            }else{
                listModel.append(item);
            }
        }
    }

}
