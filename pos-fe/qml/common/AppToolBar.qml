import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import app.models 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts 1.15
ToolBar {
    id: control
    property alias search : _search
    property alias actions : _menu.actions
    Layout.fillWidth: true
    palette.button: "transparent"
    RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{
            CMenu{
                id: _menu
                title: qsTr("Actions");
                icon:"qrc:/icons/CoreUI/free/cil-settings.svg"
                actions: tableView.actions
            }//Menu
        }//MenuBar
        HorizontalSpacer{}

        CTextField{
            id: _search
            Layout.preferredHeight: 50
            Layout.preferredWidth: 300
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            font.pixelSize: 18
            placeholderText: qsTr("Search...")
            rightIcon: "cil-search"
        }//search
    }// layout end
}
