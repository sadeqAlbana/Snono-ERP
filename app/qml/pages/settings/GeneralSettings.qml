import QtQuick
import QtQuick.Controls.Basic
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

AppPage {
    title: qsTr("General Settings")

    AppDialog {
        closePolicy: Popup.NoAutoClose
        id: progressDialog
        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Software Updates")
            padding: 25

            ColumnLayout {
                anchors.fill: parent
                Label {
                    text: qsTr("Downloading Update...")
                    font.pixelSize: 24
                }

                Connections {
                    target: NetworkManager

                    function onDownloadProgress(bytesReceived, bytesTotal) {

                        progressBar.updateValues(bytesReceived, bytesTotal)
                        progressBar.visible = true
                    }
                }

                DownloadProgressBar {
                    id: progressBar
                    Layout.preferredWidth: 400
                    Layout.preferredHeight: 60
                }
            }

//            footer: RowLayout {
//                HorizontalSpacer {}
//                CButton {
//                    palette: BrandWarning {}
//                    text: qsTr("Cancel")
//                    Layout.margins: 15
//                    onClicked: {
//                        NetworkManager.abortAllRequests(); //causes a crash
//                    }
//                }
//            }
        }
    }

    AppDialog {
        id: newUpdateDialog
        property int version: -1

        function showVersionNotification(newVersion) {
            version = newVersion
            open()
        }

        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Software Updates")
            padding: 25
            ColumnLayout {
                anchors.fill: parent
                Label {
                    text: qsTr("New version found, do you want to download it?")
                    font.pixelSize: 24
                }
            }

            footer: RowLayout {
                HorizontalSpacer {}
                CButton {
                    palette: BrandWarning {}
                    text: qsTr("Cancel")
                    Layout.margins: 15
                    onClicked: {
                        newUpdateDialog.close()
                    }
                }

                CButton {
                    palette: BrandInfo {}
                    text: qsTr("Download")
                    Layout.margins: 15
                    onClicked: {
                        progressDialog.open()
                        App.downloadVersion(newUpdateDialog.version)
                        newUpdateDialog.close();
                    }
                }
            }
        } //card
    }

    GridLayout {
        columns: 2
        rowSpacing: 20
        LayoutMirroring.childrenInherit: true
        anchors.left: parent.left

        Label {
            text: qsTr("Version: ") + App.version()
        }

        CButton {
            palette: BrandInfo {}
            text: qsTr("check for updates")

            onClicked: Api.nextVersion().subscribe(function (response) {

                if (response.status() === 404) {
                    toastrService.push(qsTr("Software Update"),
                                       qsTr("No updates found"),
                                       "warning", 2000)
                } else if (response.json('status') === 200) {
                    let nextVersion = response.json('nextVersion')
                    newUpdateDialog.showVersionNotification(nextVersion)
                }
            })
        }

        Label {
            text: qsTr("Language")
        }
        IconComboBox {
            id: language
            leftIcon.name: "cil-language"
            model: App.languages()
            valueRole: "value"
            textRole: "key"
            editable: true
            Component.onCompleted: currentIndex = indexOfValue(App.language)
        }

        Label {
            text: qsTr("Receipt Language")
        }

        IconComboBox {
            model: App.languages()
            leftIcon.name: "cil-language"
            editable: true
            valueRole: "value"
            textRole: "key"
        }
    }

    footer: AppDialogFooter {
        acceptText: qsTr("Apply")
        cancelText: qsTr("Reset")

        onAccept: {
            if (App.language !== language.currentValue) {
                App.language = language.currentValue
            }
        }
    }
}
