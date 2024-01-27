import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Views

CTableViewDelegate {

    font.bold: model._parent_id===0
}
