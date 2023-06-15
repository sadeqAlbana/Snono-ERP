import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts

Container {
    id: control
    required property bool selected
    required property bool current
    contentItem: RowLayout {}

    background: Rectangle{
        color: switch(control.TableView.view.selectionBehavior){
               case TableView.SelectCells : {
                   control.current? control.palette.active.highlight :
                                    control.TableView.view.alternatingRows?
                                        row%2==0? control.palette.alternateBase : control.palette.base :
                   control.palette.base
               }break;
               case TableView.SelectRows :{
                   !(control.TableView.view.hoveredRow===row) || (row===control.TableView.view.currentRow)? //fix
                   control.TableView.view.currentRow===model.row?control.palette.active.highlight : control.TableView.view.alternatingRows? model.row%2==0? control.palette.alternateBase : control.palette.base :
                   control.palette.base : control.palette.shadow
               }break;
               case TableView.SelectColumns :{
                   control.TableView.view.currentColumn===model.column?control.palette.active.highlight : control.TableView.view.alternatingRows? model.row%2==0? control.palette.alternateBase : control.palette.base :
                   control.palette.base;
               }
               break;
               case TableView.SelectionDisabled: {control.palette.base;} break;

               }

        border.color: control.palette.shadow
        border.width: control.TableView.view.selectionBehavior===TableView.SelectCells? control.current? 1 : 0 : 0
    }
}
