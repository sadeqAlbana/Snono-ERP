import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels 1.0
import Qt5Compat.GraphicalEffects
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import App.Models 1.0
import PosFe
AppPage{

    title: qsTr("Users")
    padding: 15
    ColumnLayout{
        id: page
        anchors.fill: parent;

        AppToolBar{
            id: toolBar
            tableView: tableView
        }


        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser{
            }

            actions: [
                //Action{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: {}},
                //Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: {}}
            ]

            model: UsersModel{
                id: model
            }//model end
        }//tableview end
    }//ColumnLayout end
}//card end

