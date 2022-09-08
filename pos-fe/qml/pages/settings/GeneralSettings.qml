import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import App.Models
import QtQuick.Dialogs
import QtCore
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

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
