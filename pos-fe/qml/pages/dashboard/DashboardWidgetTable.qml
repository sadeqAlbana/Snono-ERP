import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import "qrc:/CoreUI/components/tables"

CTableView{
    id: tableView
    horizontalHeaderView.visible: false
    property var modelRows;
    anchors.fill: parent;
    interactive: false

    model:  TableModel{
        id: tableModel
        TableModelColumn{display: "label"}
        TableModelColumn{display: "value"}
        rows: modelRows
    }
    implicitHeight: 140
    implicitWidth: 400
    rowHeightProvider: function(row){return 35}
    rowSpacing: 0
    delegate: Label{
        clip: true
        property bool accentVisible: model.row!==TableView.view.rows-1
        font.pixelSize: 18
        font.bold: column===1
        text: model.display
        color: "white"
        topPadding: 5
        bottomPadding: 5
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: 10
        Rectangle{
            visible: accentVisible
            color: "white"
            height: 1
            implicitHeight: 1
            anchors.bottom: parent.bottom
            width: parent.width
        }
    }//delegate
}
