import QtQuick
import CoreUI
import CoreUI.Forms
import QtQuick.Layouts
import PosFe

IconComboBox {
    id: control
    property bool isValid: currentText === editText

    property int parentLocationId: 0
    Layout.fillWidth: true
    implicitHeight: 50
    textRole: "name"
    valueRole: "id"
    currentIndex: 0
    editable: true
    leftIcon.name: "cil-location-pin"
    property var filter:({})
    model: BarqLocationsModel {
        filter: {"parentId" : control.parentLocationId}

    }


    onParentLocationIdChanged: {
        model.filter={"parentId":control.parentLocationId}
        model.requestData();
    }

}
