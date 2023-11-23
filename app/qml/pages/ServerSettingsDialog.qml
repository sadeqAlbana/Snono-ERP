import QtQuick
import QtQuick.Controls.Basic

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
    width: card.implicitWidth * 2
    height: card.implicitHeight * 1.2
    Card {
        id: card
        padding: 20
        anchors.fill: parent
        title: qsTr("Server Settings")
        ColumnLayout {
            anchors.fill: parent
            IconComboBox {
                id: serverCB
                font.pixelSize: 21
                editable: true
                leftIcon.name: "cil-link"
                Layout.fillWidth: true
                implicitHeight: 50

                // text: Settings.serverUrl;
                model: Settings.servers()
                currentIndex: indexOfValue(Settings.serverUrl)
                function removeElement(index) {
                    if(index===0){
                        serverCB.model=[]
                    }else{
                        serverCB.model = serverCB.model.splice(index,1)
                    }

                    Settings.setServers(serverCB.model)
                }

                delegate: CItemDelegate {
                    width: serverCB.width
                    text: serverCB.textRole ? (Array.isArray(
                                                   serverCB.model) ? modelData[serverCB.textRole] : model[serverCB.textRole]) : modelData
                    font.weight: serverCB.currentIndex === index ? Font.DemiBold : Font.Normal
                    font.family: serverCB.font.family
                    font.pointSize: serverCB.font.pointSize
                    highlighted: serverCB.highlightedIndex === index || hovered
                    hoverEnabled: serverCB.hoverEnabled

                    background: Rectangle {
                        visible: highlighted
                        color: serverCB.palette.alternateBase
                    }

                    CButton {
                        palette: BrandLight {}
                        height: parent.height / 2
                        width: height
                        radius: height
                        padding: 0
                        text: "X"
                        font.pixelSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.right
                        anchors.rightMargin: 10

                        onClicked: serverCB.removeElement(index)
                    }
                }
            }
        }

        footer: AppDialogFooter {
            acceptText: "Apply"
            cancelText: "Close"
            onAccept: {
                // Settings.setServers([])
                let text = serverCB.editText?? serverCB.currentText
                if (!text.length) {
                    return
                }

                if (serverCB.indexOfValue(text) === -1) {
                    let model = Settings.servers()
                    model.push(text)
                    Settings.setServers(model)
                    serverCB.model = model
                }

                Settings.setServerUrl(text)
                Settings.setServers(serverCB.model)
                serverCB.currentIndex=serverCB.indexOfValue(text)
                NetworkManager.reloadBaseUrl()
                dialog.close()
            }
            onCancel: dialog.close()
        }
    }
}
