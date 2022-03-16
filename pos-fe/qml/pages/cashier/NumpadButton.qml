import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Button {
    id: control
    Layout.fillWidth:true
    Layout.fillHeight: true
    Layout.minimumWidth: 50
    Layout.minimumHeight: 50
    Layout.maximumWidth: 100
    Layout.maximumHeight: 100
    Layout.alignment: Qt.AlignCenter
    implicitWidth: 75
    implicitHeight: implicitWidth
    width: 75
    height: width
    property string type
    font.family: "Open Sans Regular"
    onPressed: beep.play();
}
