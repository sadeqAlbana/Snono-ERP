import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI

CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    title: qsTr("Delivery Manifest")
    url: "/order"


    columns: 4
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("First Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "first_name"
        Layout.fillWidth: true
    }
    CLabel {
        text: qsTr("Last Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "last_name"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Phone")
    }
    CIconTextField {
        leftIcon.name: "cil-phone"
        objectName: "phone"
        Layout.fillWidth: true
    }
    CLabel {
        text: qsTr("Email")
    }
    CIconTextField {
        leftIcon.name: "cib-mail-ru"
        objectName: "email"
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Address")
    }

    CIconTextField {
        leftIcon.name: "cil-location-pin"
        objectName: "address"
        Layout.fillWidth: true
    }

    IconComboBox {
        id: cityCB
        enabled: true

        property bool isValid: currentText === editText
        Layout.fillWidth: true
        implicitHeight: 50
        textRole: "name"
        valueRole: "id"
        currentIndex: 0
        editable: true
        leftIcon.name: "cil-location-pin"

        model: BarqLocationsModel {
            id: cityModel
            //                    onDataRecevied: {
            //                        townModel.requestData();
            //                    }
        }
        onCurrentIndexChanged: {
            if (currentIndex >= 0) {
                townModel.filter = {
                    "parentId": cityModel.data(currentIndex, "id")
                }
                townCB.currentIndex = 0
            } else {

            }
        }
    }

//    IconComboBox {
//        id: townCB
//        enabled: true
//        property bool isValid: currentText === editText
//        Layout.fillWidth: true
//        implicitHeight: 50
//        textRole: "name"
//        valueRole: "id"
//        currentIndex: 0
//        editable: true
//        leftIcon.name: "cil-location-pin"

//        //                onCurrentIndexChanged:{
//        //                    var city=cityModel.data(cityCB.currentIndex,"name");
//        //                    var town=townModel.data(townCB.currentIndex,"name");
//        //                    addressLE.text=city + " - " + town

//        //                }
//        model: BarqLocationsModel {
//            id: townModel
//            filter: {
//                "parentId": 1
//            }
//            onFilterChanged: requestData()
//        }
//    }



}
