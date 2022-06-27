import QtQuick;
import QtQuick.Controls.Basic;
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
CTableViewDelegate {
    id: control
    property string suffix;
    text: model.display!==undefined ? model.display + suffix : ""
}
