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
        Label{
            text: qsTr("Language");
        }

        CComboBox{
            model: App.languages();
            editable: true
        }

        Label{
            text: qsTr("Receipt Language");
        }

        CComboBox{
            model: App.languages();
            editable: true
        }

        Label{
            text: qsTr("Country");
        }

        CComboBox{
            model: ["Iraq"]
            editable: true
        }

        Label{
            text: qsTr("Printer");
        }

        CComboBox{
            model: ["printer 1"]
        }
    }
}
