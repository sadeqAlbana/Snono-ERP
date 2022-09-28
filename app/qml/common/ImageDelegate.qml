import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
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
                fillMode: Image.PreserveAspectFit
                source: model.display? model.display : ""
                antialiasing: true

                layer.enabled: control.enabled
                layer.effect:  DropShadow{
                    radius: 32
                    verticalOffset: 1
                    spread: 0.1
                    color: "silver"
                    cached: true
                    transparentBorder: true
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
