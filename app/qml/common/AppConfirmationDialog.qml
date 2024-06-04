import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import CoreUI.Forms
import CoreUI.Base

AppDialog {
    id: control
    anchors.centerIn: parent
    width: contentWidth
    height: contentHeight
    property string title;
    property string message;
    signal accepted();
    signal canceled();
    Card{
        title: control.title

        Label{
            anchors.centerIn: parent;
            text: control.message
        }

        footer: AppDialogFooter{
            onAccept: control.accepted();
            onCancel: control.canceled();
        }
    }
}
