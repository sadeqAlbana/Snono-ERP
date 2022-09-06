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
        anchors.fill: parent
        columns: 2
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true

        Label{
            text: qsTr("Language");
        }
        CComboBox{
            id: language
            leftIcon: "cil-language"
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
            editable: true
            valueRole: "value";
            textRole: "key"

        }

        Label{
            text: qsTr("Country");
        }
        CComboBox{
            leftIcon: "cil-logo"

            model: ["Iraq"]
            editable: true
        }
    }

    footer: AppDialogFooter{
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {
            App.language=language.currentValue
        }
    }
}
