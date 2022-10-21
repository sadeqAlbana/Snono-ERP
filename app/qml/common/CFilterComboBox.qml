import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI
import PosFe
import CoreUI.Forms
import CoreUI.Views
CComboBox {
    id: control
    property string dataUrl;
    property var values: null;
    property var filter: null
    property var defaultEntry;
    property bool checkable: false  //use different delegate for checkable combo?

    currentIndex: 0
    //editable: true
    model: AppNetworkedJsonModel{
        id: jsonModel
        url: control.dataUrl
        checkable: control.checkable
        filter: control.filter?? {}

        Component.onCompleted: {            
            if(control.values){
                let emptyRecord=jsonModel.record;
                Object.keys(defaultEntry).forEach(key =>{
                    emptyRecord[key]=defaultEntry[key]
                });
                setRecords(control.values)
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
