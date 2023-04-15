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
    ColumnLayout {
        id: page
        anchors.fill: parent

        AppToolBar{
            tableView: listView
        }


        CComboBox {
            id: roleCB
            implicitWidth: 300
            Layout.fillWidth: true

            model: AclGroupsModel {
                id: aclGroupsModel

                Component.onCompleted: requestData()
            }
            valueRole: "id"
            textRole: "name"
            currentIndex: 0

            onCurrentIndexChanged: {
                let aclItems = aclGroupsModel.data(currentIndex, "items")
                aclItemsModel.uncheckAll()
                aclItemsModel.matchChecked(aclItems, "permission", "permission")
            }
        }

        CheckableListView {
            id: listView
            implicitHeight: 400
            implicitWidth: 300
            Layout.fillWidth: true
            Layout.fillHeight: true

            section.property: "category"
            section.delegate: Label {
                padding: 10
                text: section
                font.bold: true
            }

            delegate: CheckableListView.CListViewCheckDelegate {
                text: model.permission
            }

            model: AclItemsModel {
                id: aclItemsModel
                checkable: true
                //            filter: {"groupUnused":groupId}
                sortKey: "category"
                direction: "desc"

                Component.onCompleted: requestData()
            }
        }

    }
} //card end
