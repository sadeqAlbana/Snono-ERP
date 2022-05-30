import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import "qrc:/common"
import "qrc:/CoreUI/palettes"

//https://stackoverflow.com/questions/17146747/capture-qml-drawing-buffer-without-displaying

Card{
    title: qsTr("Receipt")



        Image{
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: 20
            //width: sourceSize.width
            //height: sourceSize.height

            anchors.fill: parent;
            fillMode: Image.PreserveAspectFit
            source: ReceiptGenerator.sampleData();



        }


}
