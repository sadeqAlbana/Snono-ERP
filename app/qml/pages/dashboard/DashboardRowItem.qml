import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

RowLayout {
    //color: "transparent";
    property string label : ""
    property string value : ""
    implicitHeight: labelLabel.implicitHeight>valueLabel.implicitHeight? labelLabel.implicitHeight+1 : valueLabel.implicitHeight+1
    clip: true
    Layout.fillWidth: true
    property bool showAccent : true

    Label{
        id: labelLabel
        clip: true
        leftPadding: 10
        rightPadding: 10
        topPadding: 5
        bottomPadding: 5
        font.pixelSize: 16
        text: label
        color: "white"
        Layout.fillWidth: true

        horizontalAlignment: Text.AlignLeft


    }
    Label{
        id: valueLabel
        clip: true
        font.pixelSize: 18
        font.bold: true
        text: value
        color: "white"
        topPadding: 5
        bottomPadding: 5
        Layout.fillWidth: true
        horizontalAlignment: Text.AlignLeft
        leftPadding: 10
        rightPadding: 10

    }

}
