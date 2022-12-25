import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic

import CoreUI.Forms
import CoreUI.Base

AppDialog {
    id: control
    anchors.centerIn: parent
    width: 500
    height: contentHeight
    property string title
    property string url;
    property string method: "POST"
    property var initialValues;
    property var applyHandler
    default property alias content: formView.content
    AppFormView {
        id: formView
        anchors.fill: parent
        width: parent.width
        height:parent.height
        rowSpacing: 30
        method: control.method
        url: control.url
        initialValues: control.initialValues
        title: control.title
        applyHandler: control.applyHandler
    }

}
