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
    title: qsTr("Vendors Bills")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView

        }
        PayBillDialog{
            id: dialog;
        }
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                Action{ text: qsTr("Pay"); icon.name: "cil-check"; onTriggered: dialog.open();}
            ]

            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "status"; StatusDelegate{}}
            }

            model: VendorsBillsModel{
                id: model;
            } //model
        }
    }
}

