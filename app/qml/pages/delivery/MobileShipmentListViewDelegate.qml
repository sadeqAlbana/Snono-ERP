

import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Impl
import CoreUI
import CoreUI.Buttons
import CoreUI.Palettes
ItemDelegate {
    id: control
    CoreUI.borderWidth: 1

    background: ButtonBackground{
        color: control.enabled && (control.down || control.visualFocus || control.focus || control.hovered)?  control.palette.active.button  : "transparent"
        border.color: control.palette.button
        radius: CoreUI.borderRadius
        control: control
        layer.enabled: false
    }

}
