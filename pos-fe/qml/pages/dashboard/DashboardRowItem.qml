import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Item {
    //color: "transparent";
    property string label : ""
    property string value : ""
    property int implicitContentWidth: labelLabel.implicitWidth+valueLabel.implicitWidth
    property int implicitLabelWidth: labelLabel.implicitWidth
    property int implicitValueWidth: valueLabel.implicitWidth
    implicitWidth: implicitLabelWidth>implicitValueWidth? implicitLabelWidth*2 : implicitValueWidth*2
    //implicitWidth: implicitContentWidth
//    implicitWidth: implicitLabelWidth<implicitValueWidth ?
//                       implicitLabelWidth*2>=implicitContentWidth?
//                           implicitLabelWidth*2 : implicitValueWidth*2 :  implicitValueWidth*2
    Layout.minimumWidth: implicitWidth
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
        width: parent.width/2
        //width: implicitWidth

        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
//        Rectangle{
//            color: "green"
//            height: parent.height
//            width: parent.width
//            opacity: 0.5
//        }
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

        width: parent.width/2
        //width: implicitWidth
        horizontalAlignment: Text.AlignLeft
        leftPadding: 10
        rightPadding: 10
        anchors.left: labelLabel.right
//        anchors.right: parent.right
//        anchors.horizontalCenter: parent.horizontalCenter
//        anchors.horizontalCenterOffset: implicitWidth/2
//        Rectangle{
//            color: "purple"
//            height: parent.height
//            width: parent.width
//            opacity: 0.2
//        }
    }
    Rectangle{
        color: "white"
        visible: showAccent
        height: 1
        implicitHeight: 1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottom: parent.bottom
    }

}
