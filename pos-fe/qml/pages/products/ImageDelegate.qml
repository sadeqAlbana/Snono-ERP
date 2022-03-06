import QtQuick 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
CTableViewDelegate {
    id: control
    implicitWidth: 100

    contentItem: Image{
        height: 60
        fillMode: Image.PreserveAspectFit
        source: model.display? model.display : ""
        antialiasing: true
    }
}
