import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import QtQml.Models
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/SharedComponents"
import QtQuick.Controls.impl as Impl

Item {
    id: rootItem
    implicitWidth: baseLoader.implicitWidth
    property alias stackView: baseLoader
    property bool drawerAboveContent : ApplicationWindow.window.mobileLayout
    onDrawerAboveContentChanged: {
        if(!drawerAboveContent && drawer.opened)
            drawer.close();
    }

    ToolBar{
        id: toolBar;
        anchors.left: rootItem.left
        anchors.right: rootItem.right
        anchors.leftMargin: drawerAboveContent? 0 : drawer.opened? drawer.width : 0
        height: 56
        background: Rectangle{
            border.color: "#d8dbe0"
            color: "white"
        }

        RowLayout {
            anchors.fill: parent
            ToolButton {
                Layout.leftMargin: 20
                id : toggleButton
                text: qsTr("☰")
                display: AbstractButton.TextOnly
                palette.buttonText: "#7f7f8a"
                palette.button: "#FFFFFF"
                font.pixelSize: metrics.font.pixelSize*1.5
                onClicked: drawer.opened ? drawer.close() : drawer.open();
            }

            Label {
                text: baseLoader.currentItem? baseLoader.currentItem.title : ""
                //elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                color: "#7f7f8a"
            }

            ToolButton{
               icon.name: "cil-account-logout"
               display: AbstractButton.IconOnly
               onClicked: AuthManager.logout();

            }

            ToolButton{
                id: ctrl
                display: AbstractButton.IconOnly
                icon.source: "https://coreui.io/demo/4.2/assets/img/avatars/8.jpg"
                property bool rounded: true
                property bool adapt: true
                icon.width: 48
                icon.height: 48
                implicitWidth: 48
                implicitHeight: 48
                Layout.rightMargin: 10
                Layout.alignment: Qt.AlignCenter
//                background: Rectangle{color: "transparent"}
                layer.enabled: rounded
                icon.color: "transparent"
                padding: 0

                layer.effect: OpacityMask {
                    maskSource: Item {
                        width: ctrl.width
                        height: ctrl.height
                        Rectangle {
                            anchors.centerIn: parent
                            width: ctrl.adapt ? ctrl.width : Math.min(ctrl.width, ctrl.height)
                            height: ctrl.adapt ? ctrl.height : width
                            radius: Math.max(ctrl.width, ctrl.height)
                        }
                    }
                }


            }

        }//layout

//        Rectangle{
//            anchors.fill: parent;
//            border.color: "#d8dbe0"
//            color: "transparent"
//        }


    }//toolbar

    ToolBar{
        id: breadcrumbToolbar
        y:toolBar.height
        anchors.left: rootItem.left
        anchors.right: rootItem.right
        anchors.leftMargin: drawerAboveContent? 0 : drawer.opened? drawer.width : 0
        height: 56
        background: Rectangle{

            color: "white"
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

            onCurrentIndexChanged: {
                var item=listModel.get(listView.currentIndex);
                if(item!==undefined)
                    if(item.path!==null)
                        stackView.replace(item.path)
            }
            Component.onCompleted: {
                //listView.currentIndex=1
            }

            property real delegateHeight: 0
            header : Rectangle{
                //color: drawer.background.color
                color: "#303c54"
                width: parent.width
                height: toolBar.height
                Image{
                    id: image
                    anchors.centerIn: parent;
                    source:"qrc:/images/icons/SS_Logo_Color.svg"
                    //sourceSize.width: 82
                    sourceSize.height: 72
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: ColorOverlay{
                        //anchors.fill: image
                        //source:image
                        color:"white"
                        cached: true

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
            headerPositioning: ListView.OverlayHeader

            footerPositioning: ListView.OverlayFooter



            delegate: ItemDelegate{
                id: control
                clip:true
                property bool expanded: model.expanded ? model.expanded : false
                property bool hidden: model.parentId ? model.hidden : false
                MouseArea{
                    anchors.fill: parent;
                    onPressed:(mouse)=>{
                        mouse.accepted = false;
                    }
                    cursorShape: Qt.PointingHandCursor
                }

                width: ListView.view.width
                height: 48.33
                hoverEnabled: true
                highlighted: ListView.isCurrentItem
                icon.color: "#afb5c0"
                icon.width: 17
                icon.height: 17
                icon.cache: true
                icon.name: model.image? model.image : ""
                //: "normal"
                contentItem: RowLayout{
                    anchors.fill: parent
//                    Image{
//                        id: itemImage
//                        property color color : "#afb5c0"
//                        source: model.image ? model.image : source
//                        sourceSize.width: 17
//                        sourceSize.height: 17

//                        width: 17
//                        height: 17
//                        //                        width: 56
//                        //                        height: 17.5
//                        Layout.alignment: Qt.AlignVCenter
//                        Layout.leftMargin: 13
//                        layer.enabled: true
//                        layer.effect: ColorOverlay{
//                            //id: overlay
////                            anchors.fill: itemImage
////                            source:itemImage
//                            color: itemImage.color
//                            cached: true
//                        }

//                    }



                    Impl.IconImage{
                   id: itemImage
                    name: control.icon.name
                    source: control.icon.name.length? control.icon.name : control.icon.source
                    color: control.icon.color
                    width: control.icon.width
                    height: control.icon.height
                    cache: control.icon.cache
                    fillMode: Image.PreserveAspectFit
                    Layout.alignment: Qt.AlignVCenter
                    Layout.leftMargin: 13

                    sourceSize: Qt.size(control.icon.width,control.icon.height)

                    }

                    Label{
                        id:  itemText
                        text: model.title
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

                    Badge{
                        visible: model.badge ? true : false
                        Layout.rightMargin: 13
                        width: parent.width/8
                        height: parent.height/3
                        text: model.badge ? model.badge.text : ""
                        state: model.badge ? model.badge.variant : ""
                    }

                }
                transitions:[
                    Transition {
                        from: "hidden"
//                        to: ""
                        reversible: true
                        SequentialAnimation {
                            PropertyAnimation {property: "height"; duration: 75 }
                        }
                    },
                    Transition {
                        reversible: true
                        from: "*"
                        to: "hovered"
                        ColorAnimation {
                            easing.type: Easing.InOutQuad;
                            duration: 300;
                            //alwaysRunToEnd: true
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
                        PropertyChanges {target: itemImage; color: "white"}
                        PropertyChanges {target: treeLabel; color: "white"}
                        PropertyChanges {target: treeLabel; font.bold: true}
                    },
                    State{
                        id:stateHighlighted
                        name: "highlighted"
                        when: control.highlighted
                        PropertyChanges {target: controlBackground; color: "#46546c" }
                        PropertyChanges {target: itemText; color: "white"}
                        PropertyChanges {target: itemImage; color: "white"}
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

                function indexOf(title){
                    for(var i=0; i<listModel.count; i++){
                        var item=this.get(i);
                        if(item.title===title)
                            return i
                    }
                    return -1;
                }
            }

            section.property: "category"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle{ //change to item delegate  ?
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
        modal: false
    }

    Rectangle{
        id: contentArea

        anchors{
            left: rootItem.left
            right: rootItem.right
            leftMargin: drawerAboveContent? 0 : drawer.opened? drawer.width : 0
            top: toolBar.bottom
            bottom: rootItem.bottom
        }

        color: "#ebedef"

        //content here
        StackView{
            id: baseLoader
            anchors.fill: parent
            anchors.margins: drawerAboveContent? 0 : 20
            //padding: 20

            clip:true
            //initialItem: "qrc:/pages/orders/OrdersPage.qml"
            //source: listModel.get(listView.currentIndex).path; //change this later


            replaceEnter: Transition {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
            }
            replaceExit: Transition {
                NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
            }
        }
    }

    function parseNavbar(listItems){
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
                    listModel.append(child);
                }
            }else{
                listModel.append(item);
            }
        }

        //listView.currentIndex=5
        //listView.currentIndex=30
        //listView.currentIndex=48
        //listView.currentIndex=listModel.indexOf("activities");
        //listView.currentIndex=2



        //stackView.replace(listModel.get(listView.currentIndex).path)



    }




    Component.onCompleted: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", "qrc:/nav.json");
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE) {
                var listItems = xhr.responseText;
                parseNavbar(JSON.parse(listItems));
                //listView.currentIndex=listModel.indexOf("Mobile List");
            }
        };
        xhr.send();
    }
}
