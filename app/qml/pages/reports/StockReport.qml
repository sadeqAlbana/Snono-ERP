import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import App.Models 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils


AppPage{
    title: qsTr("Products")
    padding: 10
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
                Action{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
            ]
            model: StockReportModel{
                id: model
                Component.onCompleted: requestData();

            }//model

        }
    }
}

