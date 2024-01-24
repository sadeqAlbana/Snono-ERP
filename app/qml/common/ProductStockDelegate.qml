import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Views

CTableViewDelegate {

    font.bold: model.parent_id===0

    Component.onCompleted: console.log("parent_id: " + model.parent_id)

}
