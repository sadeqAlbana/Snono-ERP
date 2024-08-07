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
import CoreUI.Palettes
import PosFe

AppPage{
    title: qsTr("Identity Settings")
    AppFormView{
        id: form
        fetchUrl: "/identity"
        applyHandler: Api.postIdentity
        anchors.fill: parent
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

        Label {
            text: qsTr("Country")
        }
        IconComboBox {
            objectName: "identity_country"
            model: App.countries();
            leftIcon.name: "cil-globe"
            textRole: "name"
            valueRole: "code"
        }


//        Image{
//            id: logo
//            Layout.rowSpan: 4
//            Layout.preferredWidth: 320
//            Layout.preferredHeight: 320

//        }


        Component.onCompleted: NetworkManager.get(form.fetchUrl).subscribe(function(res){
            form.initialValues=res.json("data");
        })
    }
}
