import QtQuick 2.12
import QtQuick.Controls 2.5

Item {
    id: rootItem
    Drawer{
        width: 0.33*rootItem.width
        height: rootItem.height
        position: 1

        Label {
            text: "Content goes here!"
            anchors.centerIn: parent
        }
    }


}
