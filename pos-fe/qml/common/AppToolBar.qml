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
    Layout.alignment: Qt.AlignVCenter
    Layout.preferredHeight: 60
    palette.button: "transparent"
    RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{
            spacing: 20
            Layout.preferredHeight: 45
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
                title: "Filter";
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
