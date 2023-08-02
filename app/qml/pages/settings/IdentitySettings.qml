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
        applyHandler: Api.postIdentity
        anchors.fill: parent
//    applyHandler: function(){}
        CLabel {
            text: qsTr("Entity Name")
        }
        CIconTextField {
            objectName: "identity_name"
            leftIcon.name: "cil-phone"
            Layout.fillWidth: true
        }

        CLabel {
            text: qsTr("Logo")
        }

        FileInput{objectName: "identity_logo";      Layout.fillWidth: true;
        }


//        Image{
//            id: logo
//            Layout.rowSpan: 4
//            Layout.preferredWidth: 320
//            Layout.preferredHeight: 320

//        }


        Component.onCompleted: NetworkManager.get(form.url).subscribe(function(res){
            console.log(JSON.stringify(res.json("data")))
            form.initialValues=res.json("data");
        })
    }
}
