import QtQuick;
import QtQuick.Controls.Basic;

import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI.Palettes
import PosFe

AppDialog {
    id: dialog
    width:  card.implicitWidth*1.2
    height: card.implicitHeight*1.2
    Card{
        id: card
        padding: 20
        anchors.fill: parent;
        title: qsTr("Server Settings");
        ColumnLayout{
            anchors.fill: parent;
            CIconTextField{
                id: serverTF
                font.pixelSize: 21
                leftIcon.name: "cil-link"
                Layout.fillWidth: true
                implicitHeight: 50
                text: Settings.serverUrl;
            }

        }

        footer: AppDialogFooter{
            acceptText: "Apply"
            cancelText: "Close"
            onAccept: {Settings.setServerUrl(serverTF.text);
                NetworkManager.reloadBaseUrl();
                dialog.close();
            }
            onCancel: dialog.close();


        }
    }


}
