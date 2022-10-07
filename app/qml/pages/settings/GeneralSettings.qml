import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels

import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage{
    title: "General Settings"
    GridLayout{
        columns: 2
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label{
            text: qsTr("Language");
        }
        CComboBox{
            id: language
            icon.name: "cil-language"
            model: App.languages();
            valueRole: "value";
            textRole: "key"
            editable: true
            Component.onCompleted: currentIndex = indexOfValue(App.language)
        }

        Label{
            text: qsTr("Receipt Language");
        }

        CComboBox{
            model: App.languages();
            icon.name: "cil-language"
            editable: true
            valueRole: "value";
            textRole: "key"
        }

        Label{
            text: qsTr("Country");
        }
        CComboBox{
            model: ["Iraq"]
            editable: true
            icon.name: "cil-globe"
        }
    }

    footer: AppDialogFooter{
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {
            if(App.language!==language.currentValue){
                App.language=language.currentValue

            }
        }
    }
}
