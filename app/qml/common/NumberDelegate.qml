import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Views
CTableViewDelegate {
    id: control
    TableView.editDelegate: CTableViewEditDelegate{
        commitHandler: function(){
            edit=parseFloat(text)
        }
    }
}
