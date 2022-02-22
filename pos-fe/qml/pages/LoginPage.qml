import QtQuick 2.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import "qrc:/CoreUI/palettes"
Rectangle {
    id : loginPage
    anchors.fill: parent;
    color: "#EBEDEF"

    signal loggedIn();
    Connections{
        target: AuthManager

        function onInvalidCredentails(){
            passwordTF.helpBlockText= qsTr("Invalid Credentials")

//            authenticated(false)
        }
    }


    Image{
        id: logo
        source: "qrc:/images/icons/SS_Logo_Color.png"
        width: 620

        sourceSize.width: 620
        fillMode: Image.PreserveAspectFit
        anchors.bottom: card.top
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        antialiasing: true
//        layer.enabled: true
//        layer.effect: ColorOverlay{
//            color: "#076596"
//        }
    }


    Card{
        id: card
        anchors.centerIn: parent;


        height: 440
        width: 620

        //anchors.verticalCenterOffset: -1*parent.height/8
        anchors.verticalCenterOffset: logo.height/2

         ColumnLayout{
             //anchors.fill: parent
             anchors.centerIn: parent;
             width: parent.width-anchors.leftMargin-anchors.rightMargin
             anchors.leftMargin: 50
             anchors.rightMargin: 50
             anchors.left: parent.left
             anchors.right: parent.right

            id: layout
            spacing: 0
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
                Layout.topMargin: 10
                spacing: 0
                CButton{
                    id: loginButton
                    implicitWidth: 80
                    text: qsTr("Login")
                    color: "#321fdb"
                    textColor: "#ffffff"
                    Layout.fillHeight: false
                    implicitHeight: 50
                    font.pixelSize: 17
                    //Layout.preferredHeight: 100
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.rightMargin: 15
                    onClicked: layout.login();
                    //icon.source:"qrc:/icons/CoreUI/free/cil-settings.svg"
                    //display: AbstractButton.TextUnderIcon
                    //icon.color: "white"
                    //icon.width: 25
                    //icon.height: 25

                    //palette: CPalette{}
                    //palette: ButtonPrimary.primary
                    //palette: Pal


                }


//                CButton{
//                    id: cancelButton
//                    text: qsTr("Cancel")
//                    color: "#e55353"
//                    textColor: "#ffffff"
//                    Layout.fillHeight: false
//                    implicitHeight: 50
//                    font.pixelSize: 17
//                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
//                    onClicked: canceled();

//                }

//                Rectangle{ //spacer
//                    color: "transparent"
//                    Layout.fillWidth: true
//                }

            }

            function login(){
                AuthManager.authenticate(usernameTF.text,passwordTF.text)
            }
            Component.onCompleted: login();
        }
    }
}
