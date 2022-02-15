import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import QtQuick.Layouts 1.15

//preferred <minimum/maximum < width/height
Page {
    id: control
    background: Rectangle{
        color: palette.window
        radius: 5

    }
    property string icon: ""
    //implicitWidth: implicitContentWidth<200? 200 : implicitContentWidth
    implicitWidth: implicitContentWidth
    Layout.minimumWidth: implicitContentWidth
    Layout.fillWidth:true
    header: Rectangle{
        color: "transparent"

        implicitHeight: 50
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
            smooth: true
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
    }

    footer:Item{
        implicitHeight: 45
    }
}
