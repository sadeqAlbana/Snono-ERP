import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

ProgressBar {
    id: control
    width: 400

    background: Rectangle{
        color: "#6c9484"
        border.color: "silver"
        radius: 5
    }

    height: 35
    contentItem: Item {
        implicitWidth: 200
        implicitHeight: 35

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: 5
            color: "#2c8558"
        }
        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            fontSizeMode: Text.Fit
            font.pixelSize: 500
            color: "#fff"
            text: ((control.value/control.to)*100)+"%"
        }
    }


}//ProgressBar
