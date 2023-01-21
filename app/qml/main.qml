import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import CoreUI
import CoreUI.Base
import CoreUI.Buttons
import CoreUI.Forms
import CoreUI.Notifications
import PosFe
import QtMultimedia
import QtQml
import CoreUI.Palettes

CApplicationWindow {
    title: qsTr("POS")
    visible: true
    property real activityCount: 0
    onActivityCountChanged: {
        if (activityCount > 0) {
            busySpinner.open()
        } else {
            busySpinner.close()
        }
    }

    FontMetrics {
        id: metrics
    }








    Component.onCompleted: {

        if (Settings.jwt != "") {
            AuthManager.testAuth()
        } else {
            rootLoader.setSource("pages/LoginPage.qml")
        }


    }
    Connections {
        target: AuthManager
        function onLoggedIn() {
            rootLoader.setSource("AppMainScreen.qml")
        }
        function onLoggedOut() {
            rootLoader.setSource("pages/LoginPage.qml")
        }
        function onTestAuthResponse(success) {
            if (success) {
                rootLoader.setSource("AppMainScreen.qml")
            } else {
                errorDlg.open()
            }
        }

        function onUserChanged(){
            CoreUI.userIcon=AuthManager.user.avatar
        }
    }

    Connections {
        target: NetworkManager

//        function onMonitoredRequestCountChanged(){

//            if(monitoredRequestCount){
//                busySpinner.open();
//            }else{
//                busySpinner.close();
//            }
//        }

//        function onNetworkActivity(url) {
//            if (url.pathname !== "/pos/cart/updateProduct"
//                    && url.pathname !== "/pos/cart/getCart") {

//                busySpinner.open()
//            }
//        }
//        function onFinishedNetworkActivity(url) {
//            if (activityCount > 0)
//                activityCount--

//            if (activityCount <= 0) {
//                busySpinner.close()
//            }
//        }

//        function onNetworkReply(status, message) {
//            if (status === 200) {
//                toastrService.push("Success", message, "success", 2000)
//            } else {
//                toastrService.push("Error", message, "error", 2000)
//            }
//        }

//        function onNetworkError(title, text) {
//            console.log(title + " " + text)
//            toastrService.push(title, text, "error", 3000)
//        }
    }

    ToastrService {
        id: toastrService
    }

    BusySpinner {
        id: busySpinner
    }

    SoundEffect {
        id: beep
        source: "qrc:/numpad_beep.wav"
    }

    SoundEffect {
        id: scannerBeep
        source: "qrc:/cashier_regiser_beep.wav"
    }

    AppDialog {
        id: errorDlg
        Card {
            anchors.fill: parent
            header.visible: true
            title: qsTr("Error")
            padding: 25
            ColumnLayout {
                anchors.fill: parent
                Label {
                    text: qsTr("Opps... an error occured, would you like to logout and try again?")
                    font.pixelSize: 24
                }
            }

            footer: RowLayout {
                HorizontalSpacer {}
                CButton {
                    palette: BrandDanger {}
                    text: qsTr("Logout")
                    Layout.margins: 15
                    onClicked: {
                        AuthManager.logout()
                        errorDlg.close();
                    }
                }
            }
        } //card
    }
}
