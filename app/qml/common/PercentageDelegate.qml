import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Views
SuffixDelegate {
    id: control
    suffix: "%"
    TableView.editDelegate: CTableViewEditDelegate{
        commitHandler: function(){
            edit=parseInt(text)
        }
    }
}
