import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import PosFe
AppPage{
    title: qsTr("Stock Report")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            tableView: tableView
            searchVisible: false

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

//            delegate: AppDelegateChooser{}

            actions: [
                CAction{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
            ]
            model: StockReportModel{
                id: model
                Component.onCompleted: requestData();

            }//model

        }
    }
}

