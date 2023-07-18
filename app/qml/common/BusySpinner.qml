import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
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

    onOpened: showTimer.start();
    Timer{
        id: showTimer;
        interval: 250;
        repeat: false

        onRunningChanged: {
            App.setMouseBusy(running);

        }
    }


    background: Rectangle{
        color: "transparent"
    }
    Overlay.modal: Rectangle {
        color: "transparent"
    }


    BusyIndicator {
        id: control
        implicitHeight: 100
        implicitWidth: 100
        anchors.centerIn: parent
        visible: showTimer.running? false : true
        running: visible
    }
}
