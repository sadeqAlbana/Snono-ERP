import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import "qrc:/CoreUI/components/tables"

TableView{
    id: tableView
    //horizontalHeaderView.visible: false
    property var modelRows;
    anchors.fill: parent;
    interactive: false
//    implicitWidth: contentWidth
    implicitHeight: contentHeight

    onWidthChanged: forceLayout();
    columnWidthProvider: function(column){return tableView.width/tableView.columns}

    model:  TableModel{
        TableModelColumn{display: "label"}
        TableModelColumn{display: "value"}
        rows: modelRows
    }
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
