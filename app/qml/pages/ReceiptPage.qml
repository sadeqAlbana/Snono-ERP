import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
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
