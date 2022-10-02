import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects

import Qt.labs.qmlmodels 1.0

import CoreUI.Palettes
import QtQuick.Pdf
//https://stackoverflow.com/questions/17146747/capture-qml-drawing-buffer-without-displaying

Card{
    title: qsTr("Receipt")



//        Image{
//            anchors.horizontalCenter: parent.horizontalCenter
//            anchors.top: parent.top
//            anchors.margins: 20
//            //width: sourceSize.width
//            //height: sourceSize.height

//            anchors.fill: parent;
//            fillMode: Image.PreserveAspectFit
//            source: ReceiptGenerator.sampleData();



//        }

        PdfPageView{
            anchors.fill: parent
            document: PdfDocument{source: "file:///"+ReceiptGenerator.sampleData();}
        }


}
