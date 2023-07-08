import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Impl

Card {
    header.visible: false
    padding: window.mobileLayout? 3 : 10
    LayoutMirroring.childrenInherit: true
}
