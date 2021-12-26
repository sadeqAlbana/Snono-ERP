import QtQuick 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
CTableViewDelegate {
    id: control

    contentItem: Image{
        anchors.centerIn: parent;
        height: 60
        fillMode: Image.PreserveAspectFit
        source: model.display? "https://"+model.display : ""
        antialiasing: true
    }
}
