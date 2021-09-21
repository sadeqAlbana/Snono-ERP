import QtQuick 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
CTableViewDelegate {
    id: control
    contentItem: Text {
        anchors.centerIn: parent
        text: model.display ? Utils.formatNumber(model.display) + " IQD" : "N.A"
        horizontalAlignment: TextEdit.AlignHCenter
        verticalAlignment: TextEdit.AlignVCenter
        color: control.textColor

    }
}