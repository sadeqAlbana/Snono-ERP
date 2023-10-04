import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import JsonModels

ColumnLayout {
    id: page
    property string title: qsTr("Create Delivery Manifest")
    property var keyValue: null

    OrderDetailsPage {
        keyValue: page.keyValue
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    CFormView {
        url: "/externalDelivery"
//        method: "POST"
//        keyValue: page.keyValue
        Layout.fillWidth: true

        CNumberInput {
            objectName: "order_id"
            text: page.keyValue;
            visible: true
        }

        IconComboBox {
            id: cityCB
            enabled: true
            objectName: "city_id"
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
            }
            onCurrentIndexChanged: {
                if (currentIndex >= 0) {
                    townModel.filter = {
                        "parentId": cityModel.data(currentIndex, "id")
                    }
                    townCB.currentIndex = 0
                }
            }
        }

        IconComboBox {
            id: townCB
            enabled: true
            objectName: "town_id"
            property bool isValid: currentText === editText
            Layout.fillWidth: true
            implicitHeight: 50
            textRole: "name"
            valueRole: "id"
            currentIndex: 0
            editable: true
            leftIcon.name: "cil-location-pin"
            model: BarqLocationsModel {
                id: townModel
                filter: {
                    "parentId": 1
                }
                onFilterChanged: requestData()
            }
        }
    }
}
