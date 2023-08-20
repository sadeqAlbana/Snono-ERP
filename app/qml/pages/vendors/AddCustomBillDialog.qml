import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent
    signal accepted(var vendorId, var products)
    parent: Overlay.overlay
    width: 900
    height: 900
    background: Rectangle {
        color: "transparent"
    }
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation {
            property: "opacity"
            from: 0.0
            to: 1.0
        }
    }

    exit: Transition {
        NumberAnimation {
            property: "opacity"
            from: 1.0
            to: 0.0
        }
    }


}
