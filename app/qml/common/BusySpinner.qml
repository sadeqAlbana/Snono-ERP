import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt5Compat.GraphicalEffects
import QtQuick.Layouts
Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay
    margins: 0
    padding: 0
    closePolicy: Popup.NoAutoClose
    width: parent.width
    height: parent.height

    property string text: ""
    property string headerText : ""
    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    contentItem: Spinner{}
}
