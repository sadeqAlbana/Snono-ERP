import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import QtQuick.Effects
CTableViewDelegate {
    id: control
    implicitWidth: 100

    contentItem: Image{
        height: 60
        fillMode: Image.PreserveAspectFit
        source: model.display? model.display : ""
        antialiasing: true
    }

    Popup{
        id: popup
        parent: control
        x:0
        y: parent.height
        padding: 0
        background: Rectangle{color: "transparent"; border.color: "transparent"}

        Image{
            width: 300
            height:300
                fillMode: Image.PreserveAspectFit
                source: model.display? model.display : ""
                antialiasing: true

                RectangularShadow {
                    anchors.fill: parent;
                    z: -1
                    radius: 3
                    offset.y: 3
                    offset.x: 3
                    spread: 2
                    color: "silver"
                    cached: true
                }
            }
    }

    MouseArea{
        anchors.fill: parent;
        hoverEnabled: true
        onContainsMouseChanged: {
            if(containsMouse)
                popup.open();
            else
                popup.close();
        }
    }
}
