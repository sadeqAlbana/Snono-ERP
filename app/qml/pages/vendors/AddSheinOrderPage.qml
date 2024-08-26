import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    header.visible: true
    url: "/sheinOrder"
    title: qsTr("Add Shein Order")
    columns: 2
    required property var orderManifest;


    // Api.addSheinOrder(selectedFile,true).subscribe(function(response){
    //     console.log(JSON.stringify(response.json()));
    // });
    Component.onCompleted: {
        NetworkManager.post("/shein/preview",{"data": orderManifest['order']}).subscribe(
                    function(res){
                    sheinModel.records=res.json('data');
                    externalReference.text=res.json("external_reference")

                    })
    }

    CLabel {
        text: qsTr("Vendor")
    }

    CFilterComboBox {
        id: cb
        objectName: "vendor_id"
        valueRole: "id"
        textRole: "name"
        Layout.fillWidth: true
        dataUrl: "/vendors"
    }


    CLabel {
        text: qsTr("External Reference")
    }
    CTextField {
        id: externalReference
        objectName: "external_reference"
        Layout.fillWidth: true
    }



    CTableView {
        // objectName: "items"
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.minimumHeight: 400
        Layout.minimumWidth: 400
        Layout.columnSpan: 2
        delegate: AppDelegateChooser {}

        model: SheinOrderManifestModel {
            id: sheinModel
        }

    }
}


