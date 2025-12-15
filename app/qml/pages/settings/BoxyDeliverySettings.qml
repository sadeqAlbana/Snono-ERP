import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI.Palettes

AppPage{
    title: qsTr("Boxy Settings")
    AppFormView{
        id: form
        url: "/boxy/config"
        anchors.fill: parent
        CLabel {
            text: qsTr("Api key")
        }
        CIconTextField {
            leftIcon.name: "cil-key"
            objectName: "api_key"
            Layout.fillWidth: true
        }

        CLabel {
            text: qsTr("Api Secret")
        }

        CIconTextField {
            leftIcon.name: "cil-lock-locked"
            objectName: "api_secret"
            Layout.fillWidth: true
            echoMode: TextInput.Password
            passwordToggleMask: true
        }

        Component.onCompleted: NetworkManager.get('boxy/config').subscribe(function(res){
            form.initialValues=res.json('data');
        })
    }
}
