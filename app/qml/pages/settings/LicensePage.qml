import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI.Palettes
import PosFe

AppPage{
    title: qsTr("License")

    TextArea{
        font.pointSize: 16
        anchors.fill: parent
        text: Settings.about();
        font.family: "Segoe UI"
        textFormat: TextEdit.MarkdownText
        wrapMode: Text.WordWrap
        readOnly: true

        onLinkActivated:(link)=> Qt.openUrlExternally(link)
    }
}
