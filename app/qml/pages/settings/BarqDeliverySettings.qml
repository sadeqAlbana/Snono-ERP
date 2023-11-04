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
    title: qsTr("Barq Settings")
    AppFormView{
        id: form
        url: "/barq/config"
        anchors.fill: parent
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

        CLabel {
            text: qsTr("Store");
        }
        CComboBox {
            id: cb
            objectName: "store_id";

            textRole: "name"
            valueRole: "id"



            model: AppNetworkedJsonModel{
                id: jsonModel
                url: "barq/stores"

                onDataRecevied: {
                    cb.model=jsonModel.toJsonArray();
                    if(form.initialValues){
                        cb.currentIndex=cb.indexOfValue(form.initialValues[cb.objectName])

                    }
                }
            }

        }

        Component.onCompleted: NetworkManager.get('barq/config').subscribe(function(res){
            console.log(JSON.stringify(res.json()))
            form.initialValues=res.json('data');
        })
    }
}
