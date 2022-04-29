import QtQuick 2.0
import QtQuick.Controls

Popup {
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    margins: 0
    padding: 0
    bottomInset: 0
    leftInset: 0
    rightInset: 0
    topInset: 0

    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }
}
