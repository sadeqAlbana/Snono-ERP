import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

// Lists the external catalogue sources that carry a given part (via the
// catalog_items.part_id link), with their price + availability + link.
AppDialog {
    id: dialog
    title: qsTr("Available Sources")

    property int partId: 0
    property string partNumber: ""
    property string partDescription: ""
    property var rows: []

    width: Math.min(760, (parent ? parent.width : 700) * 0.9)
    height: Math.min(540, (parent ? parent.height : 520) * 0.9)

    background: Rectangle {
        color: "#ffffff"
        radius: 8
        border.color: "#d0d0d0"
        border.width: 1
    }

    function openFor(pid, pnum, pdesc) {
        dialog.partId = pid
        dialog.partNumber = pnum ? pnum : ""
        dialog.partDescription = pdesc ? pdesc : ""
        dialog.rows = []
        dialog.open()
        if (pid > 0)
            Api.partSources(pid).subscribe(function (res) {
                dialog.rows = res.json("data")
            })
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        Label {
            Layout.fillWidth: true
            text: dialog.partNumber
                  + (dialog.partDescription ? ("   —   " + dialog.partDescription) : "")
            font.bold: true
            elide: Text.ElideRight
        }

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Label { text: qsTr("Source");       Layout.preferredWidth: 260; font.bold: true }
            Label { text: qsTr("Price");        Layout.preferredWidth: 130; font.bold: true }
            Label { text: qsTr("Availability"); Layout.preferredWidth: 110; font.bold: true }
            Item  { Layout.fillWidth: true }
        }

        ListView {
            id: list
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            model: dialog.rows
            ScrollBar.vertical: ScrollBar {}
            spacing: 2

            delegate: RowLayout {
                required property var modelData
                width: ListView.view.width
                spacing: 8

                Label {
                    text: modelData.source ? modelData.source : ""
                    Layout.preferredWidth: 260
                    elide: Text.ElideRight
                }
                Label {
                    text: Utils.formatNumber(modelData.price !== undefined ? modelData.price : 0)
                          + " " + (modelData.currency ? modelData.currency : "IQD")
                    Layout.preferredWidth: 130
                }
                Label {
                    text: modelData.availability ? modelData.availability : ""
                    Layout.preferredWidth: 110
                }
                CButton {
                    text: qsTr("Open")
                    palette: BrandPrimary {}
                    enabled: modelData.url ? true : false
                    onClicked: if (modelData.url) Qt.openUrlExternally(modelData.url)
                }
                Item { Layout.fillWidth: true }
            }
        }

        Label {
            Layout.fillWidth: true
            visible: dialog.rows.length === 0
            text: qsTr("No external sources carry this part yet.")
            opacity: 0.6
        }

        CButton {
            Layout.alignment: Qt.AlignRight
            text: qsTr("Close")
            palette: BrandSecondary {}
            onClicked: dialog.close()
        }
    }
}
