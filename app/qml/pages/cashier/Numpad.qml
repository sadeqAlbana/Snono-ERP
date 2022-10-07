import QtQuick;
import QtQuick.Controls.Basic;

import QtQuick.Layouts
GridLayout {
    //implicitHeight: grid.implicitHeight
    //implicitWidth: grid.implicitWidth
    signal buttonClicked(var button);
    property bool decimalEnabled: true
    property var activeButton: qty
    ButtonGroup{
        id: buttonGroup
        buttons: grid.children
        exclusive: true

    }
    function button(text){
        for(var i=0; i<buttonGroup.buttons.length; i++){
            var btn=buttonGroup.buttons[i];
            if(btn.text===text){
                return btn
            }
        }
        return null;
    }

        id: grid
        columns: 4
        columnSpacing: 10
        rowSpacing: 10
        NumpadButton { text: "7"; type: "DIGIT";  onPressed: buttonClicked(this); }
        NumpadButton { text: "8"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "9" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton {text: qsTr("Qty"); checked: true; type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this) ;id: qty; }
        NumpadButton { text: "4" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton { text: "5"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "6"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: qsTr("Disc"); type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this); }
        NumpadButton { text: "1" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton { text: "2"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "3"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: qsTr("Price"); type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this); }
        NumpadButton { text: "C"; type: "COMMAND"; palette.button: "#e55353"; palette.buttonText: "white";  onPressed: buttonClicked(this);}
        NumpadButton { text: "0"; type: "DIGIT"; onPressed: buttonClicked(this); }
        NumpadButton { text: "."; type: "COMMAND"; palette.button: "#636f83"; palette.buttonText: "white"; enabled: decimalEnabled; onPressed: buttonClicked(this); }
        NumpadButton { text: "<"; type: "COMMAND"; palette.button: "#f9b115"; palette.buttonText: "white";  onPressed: buttonClicked(this);}

    //} //end grid
}
