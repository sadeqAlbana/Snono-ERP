import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import JsonModels
//https://doc.qt.io/qt-6/qtquick-tutorials-dynamicview-dynamicview2-example.html

//https://raymii.org/s/tutorials/Qml_Drag_and_Drop_example_including_reordering_the_Cpp_Model.html
//https://stackoverflow.com/questions/36449029/how-to-drag-an-item-outside-a-listview-in-qml
import PosFe

AppPage {

    title: qsTr("Permissions")
    GridLayout {
        id: page
        anchors.fill: parent
        columns: 3
        rows:2

//        header: CIconTextField{
//            width: view.width
//            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
//            font.pixelSize: 18
//            placeholderText: qsTr("Search...")
//            rightIcon.name: "cil-search"
//            //onEntered: control.search(_search.text)
//        }//search


        DnDListView{
            id: tableView
//            title: qsTr("Role")
            Layout.fillHeight: true
            Layout.column: 0
            Layout.row: 1
            Layout.rowSpan: 2
            model: AclGroupsModel{Component.onCompleted: requestData();}

            delegate: CListViewDelegate{
                width: ListView.view.width
                onClicked: {

                    dstModel.setRecords(model.items)
                    srcModel.groupId=model.id
                }
            }


        }

        DnDListView{
            id: srcListView
            //section.labelPositioning: ListView.CurrentLabelAtStart
            Layout.rowSpan: 2

            model: AclItemsModel{
                id: srcModel
                property int groupId: 0;
                onGroupIdChanged: requestData();
                filter: {"groupUnused":groupId}
                sortKey: "category"
                direction: "desc"
                Component.onCompleted: requestData();
            }

        }
        DnDListView{
            Layout.rowSpan: 2

            id: dstListView
            model: AclDnDModel{
                id: dstModel
            }
        }

    } //ColumnLayout end
} //card end
