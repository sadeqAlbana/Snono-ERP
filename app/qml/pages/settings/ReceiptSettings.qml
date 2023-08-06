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
    title: qsTr("Receipt Settings")
    AppFormView{
        id: form
        url: "/receipt"
        applyHandler: Api.postReceipt
        anchors.fill: parent


        CLabel {
            text: qsTr("Company Name")
        }
        CIconTextField {
            objectName: "receipt_company_name"
            leftIcon.name: "cil-user"
            Layout.fillWidth: true
        }

        CLabel {
            text: qsTr("Logo")
        }

        FileInput{objectName: "receipt_logo";      Layout.fillWidth: true;
        }


        CLabel {
            text: qsTr("Phone Number")
        }
        CIconTextField {
            objectName: "receipt_phone"
            leftIcon.name: "cil-phone"
            Layout.fillWidth: true
        }

        CLabel {
            text: qsTr("Bottom Note")
        }


        CIconTextField {
            objectName: "receipt_bottom_note"
            leftIcon.name: "cil-list"
            Layout.fillWidth: true
        }



        Component.onCompleted: NetworkManager.get(form.url).subscribe(function(res){
            console.log(JSON.stringify(res.json("data")))
            form.initialValues=res.json("data");
        })
    }
}
