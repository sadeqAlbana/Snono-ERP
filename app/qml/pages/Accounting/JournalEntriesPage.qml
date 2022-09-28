import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import App.Models 1.0
import  PosFe
AppPage{
    title: qsTr("Journal Entries")
    padding: 10
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
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }
            model: JournalEntriesModel{
                id: model;
            } //model end
        }
    }
}

