import QtQuick
import QtQuick.Controls
import App.Models
import "qrc:/CoreUI/components/forms"

CComboBox {
    id: control
    property url dataUrl;
    property var filter: null
    property var defaultEntry;
    currentIndex: 0
    //editable: true
    model: NetworkModel{
        id: jsonModel
        url: control.dataUrl
        filter: control.filter
        Component.onCompleted: requestData();
        onDataRecevied: {
            jsonModel.insertRecord(defaultEntry);
            control.currentIndex=0;
        }
    }
}
