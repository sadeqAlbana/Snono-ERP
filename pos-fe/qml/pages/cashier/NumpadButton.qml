import QtQuick 2.15
import QtQuick.Controls 2.12
import QtMultimedia 5.15
Button {
    id: control
    implicitWidth: 75
    implicitHeight: implicitWidth
    width: 75
    height: width
    property string type
    font.family: "Open Sans Regular"
    onPressed: beep.play();
}
