import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import "qrc:/CoreUI/components"
import "qrc:/screens"
import "qrc:/pages"
import "qrc:/common"
import QtMultimedia 5.15
ApplicationWindow {
    visible: true
    width: 640
    height: 480
    title: qsTr("POS")
    visibility: Window.Maximized

    id: mainWindow

    Connections{
        target: AuthManager
        function onLoggedIn(){
            rootLoader.setSource("qrc:/AppMainScreen.qml")
        }
    }

    Connections{
        target: NetworkManager

        function onNetworkActivity(url){
            if(url!="/pos/cart/updateProduct" && url!="/pos/cart/getCart")
                busySpinner.open();
        }
        function onFinishedNetworkActivity(url){
            busySpinner.close();
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
