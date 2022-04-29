import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
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
        Image{
                fillMode: Image.PreserveAspectFit
                source: model.display? model.display : ""
                antialiasing: true
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
