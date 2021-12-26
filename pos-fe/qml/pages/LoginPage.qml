import QtQuick 2.12
import QtQuick.Controls 2.5
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

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

    Card{
        id: card
        anchors.centerIn: parent;

        height: 400
        width: 600

        anchors.verticalCenterOffset: -1*parent.height/8

         ColumnLayout{
             anchors.fill: parent
            id: layout
            spacing: 0
            Label{
                text: qsTr("Login")
                color: "#3C4B64"
                font.pixelSize: 50
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignLeft
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                Layout.preferredHeight: paintedHeight
            }

//            Label{
//                text: qsTr("Enter Your Password")
//                color: "#768192"
//                font.pixelSize: 16
//                Layout.fillWidth: true
//                horizontalAlignment: Text.AlignLeft
//                Layout.leftMargin: 50
//                Layout.rightMargin: 50
//                Layout.preferredHeight: paintedHeight
//            }

            CTextField{
                id: usernameTF
                Layout.fillWidth: true
                implicitHeight: 80
                Layout.preferredHeight: 80
                font.pixelSize: 22
//                echoMode: TextInput.Password
                property string helpBlockText : " "
                //onTextChanged: card.enableButtons(true);
                //leftRectVisible: true
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                placeholderText : qsTr("username...")
                text: "sadeq"
                leftIcon: "qrc:/assets/icons/coreui/free/cil-user.svg"
                helpBlock : CTextField.HelpBlockDelegate{text: usernameTF.helpBlockText; color: "red"}

            }



            CTextField{
                id: passwordTF
                Layout.fillWidth: true
                implicitHeight: 80
                Layout.preferredHeight: 80
                font.pixelSize: 22
                echoMode: TextInput.Password
                property string helpBlockText : " "
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                placeholderText : qsTr("password...")
                text: "admin"

                helpBlock : CTextField.HelpBlockDelegate{text: passwordTF.helpBlockText; color: "red"}

                leftIcon: "qrc:/assets/icons/coreui/free/cil-lock-locked.svg"

            }


            RowLayout{
                id: ftr
                layoutDirection: Qt.LeftToRight
                Layout.leftMargin: 50
                Layout.rightMargin: 50
                spacing: 0
                CButton{
                    id: loginButton
                    text: qsTr("Login")
                    color: "#321fdb"
                    textColor: "#ffffff"
                    Layout.fillHeight: false
                    implicitHeight: 50
                    font.pixelSize: 17
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.rightMargin: 15
                    onClicked: layout.login();
                }


                CButton{
                    id: cancelButton
                    text: qsTr("Cancel")
                    color: "#e55353"
                    textColor: "#ffffff"
                    Layout.fillHeight: false
                    implicitHeight: 50
                    font.pixelSize: 17
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    onClicked: canceled();

                }

                Rectangle{ //spacer
                    color: "transparent"
                    Layout.fillWidth: true
                }

            }

            function login(){
                AuthManager.authenticate(usernameTF.text,passwordTF.text)
            }
            Component.onCompleted: login();
        }
    }
}
