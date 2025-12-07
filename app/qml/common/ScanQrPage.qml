import QtQuick
import QtQuick.Controls
import QtMultimedia
import com.scythestudio.scodes 1.0

AppPage {
    id: page
    width: Qt.platform.os === "android"
           || Qt.platform.os === "ios" ? Screen.width : Screen.width
    height: Qt.platform.os === "android"
            || Qt.platform.os === "ios" ? Screen.height : Screen.height

    implicitWidth: Qt.platform.os === "android"
           || Qt.platform.os === "ios" ? Screen.width : Screen.width
    implicitHeight: Qt.platform.os === "android"
            || Qt.platform.os === "ios" ? Screen.height : Screen.height
    property bool fullScreen: true
    SBarcodeScanner {
      id: barcodeScanner

      forwardVideoSink: videoOutput.videoSink
      scanning: !resultScreen.visible

      captureRect: Qt.rect(1 / 4, 1 / 4, 1 / 2, 1 / 2)

      onCapturedChanged: function (captured) {
        scanResultText.text = captured
        resultScreen.visible = true
      }
    }

    VideoOutput {
      id: videoOutput

      anchors.fill: parent

      width: page.width

      focus: visible
      fillMode: VideoOutput.PreserveAspectCrop
    }

    Qt6ScannerOverlay {
      id: scannerOverlay

      anchors.fill: parent

      captureRect: barcodeScanner.captureRect
    }

    Rectangle {
      id: resultScreen

      anchors.fill: parent

      visible: false

      Column {
        anchors.centerIn: parent

        spacing: 20

        Text {
          id: scanResultText

          anchors.horizontalCenter: parent.horizontalCenter

          color: scannerOverlay.textColor
        }

        Button {
          id: scanButton

          anchors.horizontalCenter: parent.horizontalCenter

          implicitWidth: 100
          implicitHeight: 50

          Text {
            anchors.centerIn: parent

            text: qsTr("Scan again")
            color: scannerOverlay.textColor
          }

          onClicked: {
            resultScreen.visible = false
          }
        }
      }
    }
}
