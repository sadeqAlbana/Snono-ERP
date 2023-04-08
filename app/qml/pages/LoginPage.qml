import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI.Palettes
import PosFe

Pane {
    id : loginPage
    anchors.fill: parent;
    palette.window: "#EBEDEF"
    padding: 20
    LayoutMirroring.childrenInherit: true

    signal loggedIn();
    ServerSettingsDialog{

        id: serverSettingsDlg
    }
    Connections{
        target: AuthManager



        function onInvalidCredentails(){
            passwordTF.helpBlockText= qsTr("Invalid Credentials")

            //            authenticated(false)
        }
    }


    ColumnLayout{
        id: mainLayout
        spacing: 10
        anchors.fill: parent
        Item{
            Layout.maximumWidth: 620
            Layout.maximumHeight: 155
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitWidth: card.implicitWidth
            implicitHeight: logo.implicitHeight
            Layout.alignment: Qt.AlignCenter
            Image{
                id: logo
                source: "qrc:/images/icons/SS_Logo_Color-cropped.svg"
                fillMode: Image.PreserveAspectFit
                antialiasing: true
                anchors.fill: parent
                sourceSize.width: parent.width
//                asynchronous: true //this is important for performance reasons while resizing the window
            }
        }
        Card{
            id: card
            padding: 20
            Layout.fillWidth: true
            Layout.maximumWidth: 620
            Layout.preferredHeight: implicitHeight
            Layout.alignment: Qt.AlignCenter

            ColumnLayout{
                id: layout
                //             anchors.margins: 20
                spacing: 0
                anchors.fill: parent
                Label{
                    text: qsTr("Login")
                    color: "#3C4B64"
                    font.pixelSize: 50
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    Layout.preferredHeight: paintedHeight
                    Layout.bottomMargin: 10
                }

                Label{
                    text: qsTr("Sign in to your account")
                    color: "#768192"
                    font.pixelSize: 17
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignLeft
                    Layout.preferredHeight: paintedHeight

                    Layout.bottomMargin: 25
                }

                CIconTextField{
                    id: usernameTF
                    Layout.fillWidth: true
                    font.pixelSize: 21
                    property string helpBlockText : ""

                    placeholderText : qsTr("username...")
                    leftIcon.name: "cil-user"
                    helpBlock.text: usernameTF.helpBlockText;
                    Layout.bottomMargin: 10


                }

                CIconTextField{
                    id: passwordTF
                    Layout.fillWidth: true
                    font.pixelSize: 21
                    echoMode: TextInput.Password
                    property string helpBlockText : " "
                    placeholderText : qsTr("password...")
                    helpBlock.text: usernameTF.helpBlockText;
                    helpBlock.color: "red"
                    leftIcon.name: "cil-lock-locked"
                }
                CheckBox{
                    id: rememberMe
                    text: qsTr("Remember Me")
                    checked: false
                    font.pixelSize: 18
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.bottomMargin: 20
                }


                RowLayout{
                    id: ftr
                    layoutDirection: Qt.LeftToRight
                    spacing: 0
                    CButton{
                        id: loginButton
                        implicitWidth: 80
                        text: qsTr("Login")
                        palette: BrandPrimary{}
                        Layout.fillHeight: false
                        implicitHeight: 50
                        font.pixelSize: 17
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Layout.rightMargin: 15
                        onClicked: layout.login();
                    }

                    HorizontalSpacer{

                    }
                    CButton{
                        id: settingsButton
                        implicitWidth: 80
                        palette: BrandDanger{}
                        Layout.fillHeight: false
                        implicitHeight: 50
                        font.pixelSize: 17
                        icon.name: "cil-settings"
                        Layout.alignment: Qt.AlignVCenter
                        Layout.rightMargin: 15
                        onClicked: serverSettingsDlg.open();
                    }
                }


                function login(){
                    AuthManager.authenticate(usernameTF.text,passwordTF.text,rememberMe.checked)
                }
            }


        }//card
    }
}
