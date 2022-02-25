import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/CoreUI/palettes"
import "qrc:/common"

AppDialog {
    id: dialog
    width:  card.implicitWidth*1.2
    height: card.implicitWidth*1.2
    Card{
        id: card
        anchors.fill: parent
        padding: 20
        title: qsTr("Server Settings");


        ColumnLayout{
            anchors.fill: parent;
            CTextField{
                id: serverTF
                font.pixelSize: 21
                leftIcon: "cil-link"
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
