import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts
import "qrc:/CoreUI/palettes"

ToolBar {
    id: control
    signal search(var searchString);
    signal filterClicked(var filter);
    property var advancedFilter : null;
    required property var tableView
    property bool searchVisible: true
    Layout.fillWidth: true
    palette.button: "transparent"
    RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{
            Layout.preferredHeight: 45
            CMenu{
                title: qsTr("Actions");
                icon:"cil-settings"
                actions: tableView.actions
            }//Menu
        }//MenuBar

        CButton{
            id: btn
            palette: BrandLight{}
            onClicked: popup.open();
            Layout.preferredHeight: 45
            icon.name: "cil-list"
            text: qsTr("Columns")
            checkable: false
//            display: AbstractButton.IconOnly
            Popup{
                id: popup
                parent: btn
                y:parent.height
                leftPadding: 0
                rightPadding: 0
                palette.window: "#fff"
                palette.shadow: "silver"
                width: Math.max(flickable.contentWidth,250)
                background: Rectangle{
                    radius: 4
                    color: popup.palette.window
                    layer.enabled: true
                    layer.effect:  DropShadow{
                        radius: 8
                        verticalOffset: 1
                        spread: 0.1
                        color: popup.palette.shadow
                        cached: true
                        transparentBorder: true
                    }
                }

                Flickable{
                    id: flickable
                    clip: true
                    implicitWidth: contentWidth
                    implicitHeight: Math.min(contentHeight,400)
                    anchors.fill: parent;
                    contentHeight: layout.implicitHeight
                    flickableDirection: Flickable.VerticalFlick
                    ColumnLayout{
                        id: layout
                        anchors.fill: parent;
                        Repeater{
                            model: tableView.model.columnCount();
                            CheckDelegate{
                                text: tableView.model.headerData(modelData,Qt.Horizontal)
                                Layout.preferredHeight: 35
                                Layout.fillWidth: true
                                checkState: Qt.Checked
                                onCheckStateChanged: {
                                    if(checkState==Qt.Checked)
                                        tableView.showColumn(modelData);
                                    else{
                                        tableView.hideColumn(modelData)
                                    }
                                }
                            }//delegate
                        }//repeater
                    }//layout
                }//flickable
            }//popup
        }//button

        CButton{
            id: filter
            visible: advancedFilter
            Layout.preferredHeight: 45
            icon.name: "cil-filter"
            text: qsTr("Filter")
            palette: BrandInfo{}
            checkable: false

            onClicked: pp.open();

            TableFilter{
                id: pp
                parent: filter
                form: advancedFilter;

                onClicked: (filter)=>{
                    filterClicked(filter);
                }
            }



        }

        HorizontalSpacer{}

        CTextField{
            id: _search
            visible: searchVisible
            Layout.preferredHeight: 50
            Layout.preferredWidth: 300
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            font.pixelSize: 18
            placeholderText: qsTr("Search...")
            rightIcon: "cil-search"
            onEntered: control.search(_search.text)
        }//search
    }// layout end
}
