import QtQuick;import QtQuick.Controls.Basic;
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
    required property var tableView
    Layout.fillWidth: true
    palette.button: "transparent"
    contentItem: RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{
            CMenu{
                id: _menu
                title: qsTr("Actions");
                icon:"cil-settings"
                actions: tableView.actions
            }//Menu
        }//MenuBar

        CButton{
            id: btn
            onClicked: popup.open();
            Layout.preferredHeight: 55
            icon.name: "cil-list"
            palette: BrandInfo{}
            checkable: false
            display: AbstractButton.IconOnly
            Popup{
                id: popup
                parent: btn
                y:parent.height
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
                        Repeater{
                            model: tableView.model.columnCount();
                            CheckBox{
                                text: tableView.model.headerData(modelData,Qt.Horizontal)
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
            Layout.preferredHeight: 55
            icon.name: "cil-list"
            palette: BrandInfo{}

            checkable: false

            text: qsTr("scroll down")
            onClicked: tableView.contentY=tableView.contentHeight
        }

        HorizontalSpacer{}

        CTextField{
            id: _search
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
