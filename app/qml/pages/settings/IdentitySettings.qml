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
    title: "Identity Settings"
    AppFormView{
        id: form
        url: "/identity"
        anchors.fill: parent
//    applyHandler: function(){}
        CLabel {
            text: qsTr("Entity Name")
        }
        CIconTextField {
            leftIcon.name: "cil-phone"
            objectName: "name"
            Layout.fillWidth: true
        }

        CLabel {
            text: qsTr("Logo")
        }


//        Component.onCompleted: NetworkManager.get('/barq/config').subscribe(function(res){
//            form.initialValues=res.json('data');
//        })
    }
}
