import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
import Qt5Compat.GraphicalEffects
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils


import PosFe
AppPage{

    title: qsTr("Orders Returns")
    padding: 15
    ColumnLayout{
        id: page
        anchors.fill: parent;

        AppToolBar{
            id: toolBar
            tableView: tableView

            onSearch: {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }
        }


        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser{
            }

            actions: [
                //CAction{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: {}},
                //CAction{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: {}}
            ]

            model: OrdersReturnsModel{
                id: model

            }//model end
        }//tableview end
    }//ColumnLayout end
}//card end

