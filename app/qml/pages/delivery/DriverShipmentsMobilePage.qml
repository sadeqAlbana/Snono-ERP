import QtCore
import QtQuick
import QtMultimedia
import PosFe
import QtQuick.Controls
AppPage {
    id: page
    CameraPermission {
        id: cameraPermission
    }

    CaptureSession {
        imageCapture : ImageCapture {
            id: imageCapture
        }
        camera: Camera {
            id: camera
        active: cameraPermission.status === Qt.PermissionStatus.Granted
        }

        videoOutput: videoOutput
    }
    VideoOutput {
        id: videoOutput
        anchors.fill: parent

        RoundButton {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 50
            radius: width
            icon.name: "cil-fiber-manual"
            onClicked: {
                imageCapture.capture();
                photoPreview.visible=true
            }
        }
    }

    Image {
        id: photoPreview
        source: imageCapture.preview // always shows the last captured image
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
        RoundButton {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.topMargin: 10
            radius: width
            icon.name: "cil-x"
            onClicked: {
                photoPreview.visible=false;
            }
        }
    }

    Component.onCompleted: cameraPermission.request()

}
