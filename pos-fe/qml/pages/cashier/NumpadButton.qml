import QtQuick 2.15
import QtQuick.Controls 2.12
import QtMultimedia 5.15
Button {
    id: control
    implicitWidth: 80
    implicitHeight: implicitWidth
    width: 80
    height: width
    property string type
    font.family: "Open Sans Regular"
    onPressed: beep.play();
}
