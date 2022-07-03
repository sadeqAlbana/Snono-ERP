import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Layouts
import "qrc:/CoreUI/components"
import "qrc:/screens"
import "qrc:/pages"
import "qrc:/common"
import QtMultimedia
ApplicationWindow {
    id: mainWindow
    visible: true
    title: qsTr("POS")
    width: 640
    height: 480
    visibility: Window.Maximized
    minimumWidth: rootLoader.implicitWidth
    minimumHeight: rootLoader.implicitHeight
    property real activityCount : 0
    property bool mobileLayout : height>width

    onActivityCountChanged:{
        //console.log(activityCount)
        if(activityCount>0){
            busySpinner.open();
        }else{
            busySpinner.close();
        }
    }

    FontMetrics{
        id: metrics
    }
    Connections{
        target: AuthManager
        function onLoggedIn(){
            rootLoader.setSource("qrc:/AppMainScreen.qml")
        }
    }

    Connections{
        target: NetworkManager
        function onNetworkActivity(url){
            console.log("netweork accitivity")
            activityCount++;
            if(url.pathname!=="/pos/cart/updateProduct" && url.pathname!=="/pos/cart/getCart"){
                busySpinner.open();
                console.log("opened busy spinner")

            }
        }
        function onFinishedNetworkActivity(url){
            if(activityCount>0)
                activityCount--;

            //busySpinner.close();
        }

        function onNetworkReply(status,message){
            if(status===200){
                toastrService.push("Success",message,"success",2000)
            }
            else{
                toastrService.push("Error",message,"error",2000)
            }
        }

        function onNetworkError(title,text){
            console.log(title + " " + text)
            toastrService.push(title,text,"error",3000)
        }
    }


    ToastrService{
        id: toastrService
    }




    BusySpinner{
        id: busySpinner
    }



    Loader {
        id : rootLoader
        anchors.fill: parent
//        width: parent.width
//        height: parent.height
        sourceComponent: LoginPage{

        }
    }

    SoundEffect{
        id: beep
        source: "qrc:/numpad_beep.wav"
    }

    SoundEffect{
        id: scannerBeep
        source: "qrc:/cashier_regiser_beep.wav"
    }

}
