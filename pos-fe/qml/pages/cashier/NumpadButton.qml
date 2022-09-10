import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
Button {
    id: control
    Layout.fillWidth:true
    Layout.fillHeight: true
    Layout.minimumWidth: 40
    Layout.minimumHeight: 40
    Layout.maximumWidth: 100
    Layout.maximumHeight: 100
    Layout.alignment: Qt.AlignCenter
    implicitWidth: 50
    implicitHeight: implicitWidth
    width: 75
    height: width
    property string type
    font.family: "Open Sans Regular"
    onPressed: beep.play();
}
