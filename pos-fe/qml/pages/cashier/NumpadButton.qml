import QtQuick 2.15
import QtQuick.Controls 2.12
import QtMultimedia 5.15
Button {
    id: control
    width: 100
    height: 100
    property string type

    font.family: "Open Sans Regular"

    //font.pixelSize: height * fontHeight
    onPressed: beep.play();




}
