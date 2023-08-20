import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import "qrc:/PosFe/qml/screens/utils.js" as Utils


AppProgressBar{
    id: control
    property real received
    property real total
    bottomInset: progressText.implicitHeight
    bottomPadding: bottomInset+padding
    function updateValues(received,total){

        control.received=received.toFixed(2);
        control.total=total.toFixed(2);
        control.value=parseFloat(received/total).toFixed(2)

    }


    Text {
        id: progressText
        width: control.width
        height: implicitHeight
        anchors.bottom: control.bottom
        anchors.left: control.left
        anchors.right: control.right
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 25
        color: "#000"
        text: Utils.niceBytes(control.received) + " / " + Utils.niceBytes(control.total)
    }
}
