import QtQuick
import QtQuick.Controls
import App.Models
import "qrc:/CoreUI/components/forms"

CComboBox {
    id: control
    property string dataUrl;
    property var values: null;
    property var filter: null
    property var defaultEntry;
    currentIndex: 0
    //editable: true
    model: NetworkModel{
        id: jsonModel
        url: control.dataUrl
        filter: control.filter?? {}

        Component.onCompleted: {            
            if(control.values){
                let emptyRecord=jsonModel.record;
                Object.keys(defaultEntry).forEach(key =>{
                    emptyRecord[key]=defaultEntry[key]
                });
                setupData(control.values)
                insertRecord(emptyRecord);
                control.currentIndex=0;
            }
            if(dataUrl.length){
                jsonModel.requestData();
            }

        }

        onDataRecevied: {
            let emptyRecord=jsonModel.record;
            Object.keys(defaultEntry).forEach(key=>{
                emptyRecord[key]=defaultEntry[key]
            });
            jsonModel.insertRecord(emptyRecord);
            control.currentIndex=0;
        }
    }
}
