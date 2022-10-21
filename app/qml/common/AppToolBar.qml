import QtQuick;

import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects

import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts
import CoreUI.Palettes
import CoreUI.Menus
CToolBar {
    id: control
    signal search(var searchString);
    signal filterClicked(var filter);
    property var advancedFilter : null;
    required property var tableView
    property bool searchVisible: true
    background: Rectangle{color: "transparent"}
    Layout.fillWidth: true
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 60
    palette.button: "transparent"
    leftPadding: 10
    rightPadding: 10
    RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{

            spacing: -5
            Layout.preferredHeight: 50
            Layout.alignment: Qt.AlignVCenter
            CActionsMenu{
                title: qsTr("Actions");
                icon:"cil-settings"
                actions: tableView.actions
            }//Menu

            CMenu{
                title: qsTr("columns");
                icon:"cil-list"
                Repeater{
                    model: tableView.columns
                    CMenuItem{
                        checkable: true
                        text: tableView.model.headerData(modelData,Qt.Horizontal)
                        palette.windowText: enabled? hovered? "#fff" : "#000" : "silver"
                        checked: true
                        onCheckedChanged: {
                            if(checked)
                                tableView.showColumn(modelData);
                            else{
                                tableView.hideColumn(modelData)
                            }
                        }
                    }
                }
            }//Menu



            CFilterMenu{
                padding: 20
                spacing: 1
                title: qsTr("Filter");
                icon: "cil-filter"
                onClicked: (filter)=> {
                               control.filterClicked(filter);
                           }


                //it's better to implement a custom content item
                model: control.advancedFilter
            }



            //now delegate choice for filter
        }//MenuBar

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
