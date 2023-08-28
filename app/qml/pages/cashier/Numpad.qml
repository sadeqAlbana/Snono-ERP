import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import PosFe
import CoreUI.Palettes
GridLayout {
    //implicitHeight: grid.implicitHeight
    //implicitWidth: grid.implicitWidth
    signal buttonClicked(var button);
    ButtonGroup{
        id: buttonGroup
        buttons: grid.children
        exclusive: true

    }

    KeyEmitter{
        id: emitter
    }

    Connections{
        target: grid
    function onButtonClicked(button) {
        if(button.type===NumpadButton.Type.Normal)
            emitter.pressKey(button.key)
        else if(button.type===NumpadButton.Type.Macro){
            button.macro.forEach(key =>{
                emitter.pressKey(key)
            });
        }
    }
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
        columns: 3
        columnSpacing: 10
        rowSpacing: 10
        NumpadButton { text: "1" ; key: Qt.Key_1 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this);}
        NumpadButton { text: "2";  key: Qt.Key_2 ; type: NumpadButton.Type.Normal;  onPressed: buttonClicked(this);}
        NumpadButton { text: "3";  key: Qt.Key_3 ; type: NumpadButton.Type.Normal;  onPressed: buttonClicked(this);}
        NumpadButton { text: "4" ;key: Qt.Key_4 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this);}
        NumpadButton { text: "5";key: Qt.Key_5 ; type: NumpadButton.Type.Normal;  onPressed: buttonClicked(this);}
        NumpadButton { text: "6"; key: Qt.Key_6 ; type: NumpadButton.Type.Normal;  onPressed: buttonClicked(this);}
        NumpadButton { text: "7"; key: Qt.Key_7 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this); }
        NumpadButton { text: "8"; key: Qt.Key_8 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this);}
        NumpadButton { text: "9" ; key: Qt.Key_9 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this);}
        NumpadButton { text: "."; key: Qt.Key_Period ; type: NumpadButton.Type.Normal; palette.button: "#636f83"; palette.buttonText: "white";  onPressed: buttonClicked(this); }
        NumpadButton { text: "0"; key: Qt.Key_0 ; type: NumpadButton.Type.Normal; onPressed: buttonClicked(this); }
        NumpadButton { text: "<"; key: Qt.Key_Backspace; type: NumpadButton.Type.Special; palette: BrandDanger{}  onPressed: buttonClicked(this);}

    //} //end grid
}
