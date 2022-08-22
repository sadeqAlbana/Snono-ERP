import QtQuick
import QtQuick.Controls.Basic;
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
ButtonPopup {
    id: popup

    property var form: [
        {"type": "text","label": "name","key": "name"}
    ]
    Component{
        id: textFilter;
        CTextField{
            Layout.fillWidth: true
        }
    }

    Flickable{
        id: flickable
        clip: true
        implicitWidth: contentWidth
        implicitHeight: Math.min(contentHeight,400)
        anchors.fill: parent;
        contentWidth: layout.implicitWidth
        contentHeight: layout.implicitHeight
        flickableDirection: Flickable.VerticalFlick
        ColumnLayout{
            id: layout
            anchors.fill: parent;

        }//layout
    }//flickable

    Component.onCompleted: {
        form.forEach(item => {
                     if(item.type==="text"){
                             let txt=textFilter.createObject(layout);
                             txt.placeholderText =item.label
                         }
                     });
    }
}
