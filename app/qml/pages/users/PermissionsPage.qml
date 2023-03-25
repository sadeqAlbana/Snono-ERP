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

        CListView{
            title: qsTr("Role")
            Layout.fillHeight: true
            Layout.fillWidth: true
            model: AclGroupsModel{Component.onCompleted: requestData();}

            delegate: CListViewDelegate{
                width: ListView.view.width
                onClicked: {
                    dstModel.setRecords(model.items)
                }
            }


        }

        DnDListView{
            id: srcListView
            //section.labelPositioning: ListView.CurrentLabelAtStart
            model: AclItemsModel{
                id: srcModel
                filter: {"groupUnused":2}
                sortKey: "category"
                direction: "desc"
                Component.onCompleted: requestData();
            }

        }
        DnDListView{
            id: dstListView
            model: AclDnDModel{
                id: dstModel
            }
        }

    } //ColumnLayout end
} //card end
