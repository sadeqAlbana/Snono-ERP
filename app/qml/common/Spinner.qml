import QtQuick
import QtQuick.Controls
//import QtQuick.Controls.Basic

BusyIndicator {
       id: control
       implicitHeight: 75
       implicitWidth: 75
       width: 75
       height: 75
//       property int circleSize: 64
//       contentItem: Item {
//           implicitWidth: 64
//           implicitHeight: 64
//           Item {
//               x: parent.width / 2 - 32
//               y: parent.height / 2 - 32
//               width: circleSize
//               height: circleSize
//               opacity: control.running ? 1 : 0

//               Behavior on opacity {
//                   OpacityAnimator {
//                       duration: 250
//                   }
//               }

//               RotationAnimator {
//                   target: parent
//                   running: control.visible && control.running
//                   from: 0
//                   to: 360
//                   loops: Animation.Infinite
//                   duration: 1250
//               }

//               Repeater {
//                   model: 6

//                   Rectangle {
//                       x: circleSize / 2 - width / 2
//                       y: circleSize / 2 - height / 2
//                       implicitWidth: 10
//                       implicitHeight: 10
//                       radius: 5
//                       color: "orange"
//                       transform: [
//                           Translate {
//                               y: -Math.min(circleSize, circleSize) * 0.5 + 5
//                           },
//                           Rotation {
//                               angle: index / 6 * 360
//                               origin.x: 5
//                               origin.y: 5
//                           }
//                       ]
//                   }
//               }
//           }
//       }
   }
