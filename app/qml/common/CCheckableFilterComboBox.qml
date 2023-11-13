import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI
import PosFe
import CoreUI.Forms
import CoreUI.Views
CCheckableComboBox {
    id: control
    property string dataUrl;
    property var values: null;
    property var filter: null
    property bool checkable: true  //use different delegate for checkable combo?
    currentIndex: 0
    //editable: true

    function clearSelection(){
        model.uncheckAll();
    }

    model: AppNetworkedJsonModel{
        id: jsonModel
        url: control.dataUrl
        checkable: control.checkable
        filter: control.filter?? {}

        Component.onCompleted: {
            if(control.values){
                setRecords(control.values)
                control.currentIndex=0;
            }
            if(dataUrl.length){
                jsonModel.requestData();
            }
        }


    }
}
