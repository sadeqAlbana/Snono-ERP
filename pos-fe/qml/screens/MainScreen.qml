import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
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

        width: 250

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

            delegate: ItemDelegate{
                id: control

                MouseArea{
                    anchors.fill: parent;
                    onPressed:  mouse.accepted = false
                    cursorShape: Qt.PointingHandCursor

                }

                width: parent.width;
                hoverEnabled: true
                highlighted: ListView.isCurrentItem
                state: "normal"
                contentItem: RowLayout{

                    Image{
                        id: itemImage
                        source: model.image
                        sourceSize.width: 17
                        sourceSize.height: 17
                        Layout.alignment: Qt.AlignVCenter
                        ColorOverlay{
                            anchors.fill: itemImage
                            source:itemImage
                            color:"white"

                        }

                    }
                    Label{
                        id:  itemText
                        text:model.title
                        color : "#d4d7dd"
                        Layout.alignment: Qt.AlignLeft

                        font.family: "-apple-system,BlinkMacSystemFont,segoe ui,Roboto,helvetica neue,Arial,noto sans,sans-serif,apple color emoji,segoe ui emoji,segoe ui symbol,noto color emoji"
                        font.bold: false
                        font.pixelSize: 14

                    }

                }





                states: [
                    State{
                        name: "hovered"
                        when: control.hovered
                        PropertyChanges {target: controlBackground; color: "#321fdb"}
                        PropertyChanges {target: itemText; color: "white"}


                    },
                    State{
                        name: "highlighted"
                        when: control.highlighted
                        PropertyChanges {target: controlBackground; color: "#46546c" }
                        PropertyChanges {target: itemText; color: "white"}

                    },
                    State{
                        name: "normal"
                        PropertyChanges {target: controlBackground; color: drawer.background.color }
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

                }

            }

            model: ListModel{
                ListElement {title:  "Dashboard"; image: "qrc:/icons/coreui/free/cil-speedometer.svg";}
                ListElement {title:  "Colors"; image: "qrc:/icons/dark/appbar.calendar.range.png";  category:  "THEME"; }
                ListElement {title:  "Typography"; image: "qrc:/icons/dark/appbar.calendar.range.png";  category:  "THEME"}

                ListElement {title:  "Base"; image: "qrc:/icons/dark/appbar.calendar.range.png";  category:  "COMPONENTS";}
            }

            section.property: "category"
            section.criteria: ViewSection.FullString
            section.delegate: Rectangle{
                id: sectionHeading
                width: parent.width
                height: toolBar.height
                color: drawer.background.color;
                //color: "red"

                Label {
                    text: section
                    font.bold: true
                    font.pixelSize: 10
                    anchors.left:parent.left
                    height: parent.height
                    verticalAlignment: Qt.AlignVCenter
                    anchors.leftMargin: 10

                    color: "#d4d7dd"

                }
            }


        }
    }

}
