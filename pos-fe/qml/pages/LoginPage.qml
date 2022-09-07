import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Controls
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/CoreUI/palettes"
import "qrc:/common"

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
            //Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.maximumWidth: 620
            Layout.maximumHeight: 400
            Layout.alignment: Qt.AlignCenter
            //Layout.minimumWidth: implicitWidth
            //anchors.verticalCenterOffset: -1*parent.height/8
            //anchors.verticalCenterOffset: logo.height/2
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

                CTextField{
                    id: usernameTF
                    Layout.fillWidth: true
                    Layout.preferredHeight: 71
                    font.pixelSize: 21
                    //                echoMode: TextInput.Password
                    property string helpBlockText : " "
                    //onTextChanged: card.enableButtons(true);
                    //leftRectVisible: true

                    placeholderText : qsTr("username...")
                    text: "sadeq"
                    leftIcon: "cil-user"
                    helpBlock : CTextField.HelpBlockDelegate{text: usernameTF.helpBlockText; color: "red"}

                }

                CTextField{
                    id: passwordTF
                    Layout.fillWidth: true
                    Layout.preferredHeight: 71
                    font.pixelSize: 21
                    echoMode: TextInput.Password
                    property string helpBlockText : " "
                    placeholderText : qsTr("password...")
                    text: "admin"
                    helpBlock : CTextField.HelpBlockDelegate{text: passwordTF.helpBlockText; color: "red"}
                    leftIcon: "cil-lock-locked"
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
                    AuthManager.authenticate(usernameTF.text,passwordTF.text)
                }
                //Component.onCompleted: login();
            }


        }//card
    }
}
