import QtQuick
import QtQuick.Controls.Basic

Image{
    id: image
    BusyIndicator{
        running: image.status===Image.Loading
        anchors.fill: parent;
        width: 55
        height: 55
    }
}
