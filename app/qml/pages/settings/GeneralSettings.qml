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
import CoreUI.Palettes
AppPage{
    title: qsTr("General Settings")




    GridLayout{
        columns: 2
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label{
            text: qsTr("Version: ")+ App.version();
        }

        CButton{
            palette: BrandInfo{}
            text: qsTr("check for updates")

            onClicked: Api.nextVersion().subscribe(function(response){


                if(response.status()===404){
                    toastrService.push(qsTr("Software Update"), qsTr("No updates found"), "warning", 2000)
                }else if(response.json('status')===200){
                    let nextVersion=response.json('nextVersion');
                    App.downloadVersion(nextVersion);
                }

            });
        }

        Label{
            text: qsTr("Language");
        }
        IconComboBox{
            id: language
            leftIcon.name: "cil-language"
            model: App.languages();
            valueRole: "value";
            textRole: "key"
            editable: true
            Component.onCompleted: currentIndex = indexOfValue(App.language)
        }

        Label{
            text: qsTr("Receipt Language");
        }

        IconComboBox{
            model: App.languages();
            leftIcon.name: "cil-language"
            editable: true
            valueRole: "value";
            textRole: "key"
        }

        Label{
            text: qsTr("Country");
        }
        IconComboBox{
            model: ["Iraq"]
            editable: true
            leftIcon.name: "cil-globe"
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
