import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Views
import Qt.labs.qmlmodels
import JsonModels

Card {
    id: page
    property var initialValues: null
    property var applyHandler
    CTabView {
        id: tabView
        anchors.fill: parent
        Card {
            title: qsTr("Items")

            header.visible: false

            ColumnLayout {
                anchors.fill: parent
                CTableView {
                    id: tableView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignTop

                    selectionBehavior: TableView.SelectCells

                }//TableView

            }
        }
    } //tabview
}
