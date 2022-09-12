import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts

//preferred <minimum/maximum < width/height
Page {
    id: control
    property string icon: ""
    //implicitWidth: implicitContentWidth<200? 200 : implicitContentWidth
//    implicitWidth: control.implicitContentWidth
    Layout.minimumWidth: implicitWidth
    Layout.fillWidth:true
    header: Rectangle{
        color: "transparent"

        implicitHeight: 50
        implicitWidth: image.implicitWidth+ 25+label.implicitHeight
        Image{
            id: image
            anchors.margins: 5
            anchors.left: parent.left
            anchors.top: parent.top
            source: control.icon
            height: parent.height*0.5
            anchors.leftMargin: 5

            sourceSize.height: height
            sourceSize.width: width
            antialiasing: true
            //width: parent.height
            fillMode: Image.PreserveAspectFit

            anchors.verticalCenter: parent.verticalCenter
            layer.enabled: true
            layer.effect: ColorOverlay{
                color: "white"
                cached: true

            }
        }
        Label{
            id: label
            font.pixelSize: 17
            font.bold: true
            text: control.title
            anchors.leftMargin: 15
            anchors.left: image.right
            anchors.top: parent.top
            height: parent.height

            color: "white"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

        }
    }//header

    footer:Item{
        implicitHeight: 40
    }//footer

    background: Rectangle{
        color: palette.window
        radius: 5
    }
}
