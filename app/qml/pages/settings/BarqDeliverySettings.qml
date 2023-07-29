import QtQuick;
import QtQuick.Controls.Basic;
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

AppPage{
    title: "Barq Settings"
    AppFormView{
        id: form
        url: "/barq/config"
        anchors.fill: parent
//    applyHandler: function(){}
        CLabel {
            text: qsTr("Agent Phone")
        }
        CIconTextField {
            leftIcon.name: "cil-phone"
            objectName: "phone"
            Layout.fillWidth: true
            helpBlock.text: qsTr("Invalid Phone Number")
            validator: RegularExpressionValidator{
                regularExpression: /^(?:\d{2}-\d{3}-\d{3}-\d{3}|\d{11})$/
            }
        }

        CLabel {
            text: qsTr("Agent Password")
        }

        CIconTextField {
            id: tf
            leftIcon.name: "cil-lock-locked"
            objectName: "password"
            Layout.fillWidth: true
            echoMode: TextInput.Password
            passwordToggleMask: true
        }
        Component.onCompleted: NetworkManager.get('/barq/config').subscribe(function(res){
            form.initialValues=res.json('data');
        })
    }
}
