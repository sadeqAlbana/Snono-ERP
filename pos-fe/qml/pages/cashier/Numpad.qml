import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
Item{
    implicitHeight: grid.childrenRect.height
    implicitWidth: grid.childrenRect.width
    signal buttonClicked(var button);
    property bool decimalEnabled: true
    property var activeButton: qty
    ButtonGroup{
        id: buttonGroup
        buttons: grid.children
        //onClicked: buttonClicked(button);
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

    Grid {
        id: grid
        columns: 4
        columnSpacing: 10
        rowSpacing: 10
        NumpadButton { text: "7"; type: "DIGIT";  onPressed: buttonClicked(this); }
        NumpadButton { text: "8"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "9" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton {id: qty; checked: true; text: "Qty"; type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this)}
        NumpadButton { text: "4" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton { text: "5"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "6"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "Disc"; type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this); }
        NumpadButton { text: "1" ; type: "DIGIT"; onPressed: buttonClicked(this);}
        NumpadButton { text: "2"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "3"; type: "DIGIT";  onPressed: buttonClicked(this);}
        NumpadButton { text: "Price"; type: "SPECIAL"; checkable: true; palette.button: "#3399ff"; palette.buttonText: "white"; onPressed: buttonClicked(this); }
        NumpadButton { text: "C"; type: "COMMAND"; palette.button: "#e55353"; palette.buttonText: "white";  onPressed: buttonClicked(this);}
        NumpadButton { text: "0"; type: "DIGIT"; onPressed: buttonClicked(this); }
        NumpadButton { text: "."; type: "COMMAND"; palette.button: "#636f83"; palette.buttonText: "white"; enabled: decimalEnabled; onPressed: buttonClicked(this); }
        NumpadButton { text: "<"; type: "COMMAND"; palette.button: "#f9b115"; palette.buttonText: "white";  onPressed: buttonClicked(this);}

    } //end grid
}
