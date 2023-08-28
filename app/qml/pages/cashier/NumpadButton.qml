import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Palettes
Button {
    id: control

    property int key: 0
    property var macro;
    palette: BrandInfo{}
    enum Type{
        Normal,
        Macro,
        Special
    }
    required property int type
    display: AbstractButton.TextBesideIcon
    Layout.fillWidth:true
    Layout.fillHeight: true
    Layout.minimumWidth: 20
    Layout.minimumHeight: 20
    Layout.maximumWidth: 100
    Layout.maximumHeight: 100
    Layout.alignment: Qt.AlignCenter
    implicitWidth: 40
    implicitHeight: implicitWidth
    width: 40
    height: 40
    text: key
        focusPolicy: Qt.NoFocus
    font.family: "Open Sans Regular"
    onPressed: beep.play();
}
