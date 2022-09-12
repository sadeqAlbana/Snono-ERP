import QtQuick 2.0
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Material 2.3

Item {
    id: login
    anchors.fill: parent;
    visible: true

    signal loggedIn();
    Connections{
        target: AuthManager
        onLoggedIn: {
            authenticated(true);
        }
        onInvalidCredentails:{
            authenticated(false)
        }
    }

        ColumnLayout{
            anchors.centerIn: parent;

            TextField{
                Layout.fillWidth: true
                id: usernameTF
                placeholderText: "username..."
                focus: true
                text:"sadeq"

            }
            TextField{
                Layout.fillWidth: true
                id: passwordTF
                echoMode: TextInput.Password
                placeholderText: "password..."
                focus: true
                text: "admin"
            }


            Label{
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                id: credentialsLabel
                color: "red"
                text: "Invalid Credentials";
                font.italic: true;
                opacity: 0;
            }



            RowLayout{
                Layout.fillWidth: true
                Button{
                    Layout.fillWidth: true
                    id: loginButton
                    text: qsTr("Login")
                    onClicked: loginButtonPressed();
                }
                Button{
                    Layout.fillWidth: true
                    id: quitButton
                    text: qsTr("Quit")
                }
            }

        }




    function loginButtonPressed(){
        AuthManager.authenticate(usernameTF.text,passwordTF.text);

    }

    function authenticated(success){
        if(success){
            credentialsLabel.opacity=0
            loggedIn();
        }
        else{
            credentialsLabel.opacity=1
        }
    }

    function hide(){
        this.visible=false;
    }

    function show(){
        this.visible=true;
    }

    onLoggedIn: {
        this.hide();
        rootLoader.setSource("qrc:/screens/MainScreen.qml");
    }

    Component.onCompleted: {
        //loginButtonPressed();
    }


}


