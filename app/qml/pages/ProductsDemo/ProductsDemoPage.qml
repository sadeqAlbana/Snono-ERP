import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage {
    title: qsTr("Products")


    GridView{

        anchors.fill: parent;



        model: ProductsModel{
             filter: {"parentage":["have_variants","variantless"]}

        }

        cellWidth: 400
        cellHeight: 500


        delegate: Card{
            GridLayout {
                columns: 2
                anchors.fill: parent
                Image {
                    Layout.columnSpan: 2
                    Layout.alignment: Qt.AlignCenter
                    Layout.maximumWidth: 300
                    fillMode: Image.PreserveAspectFit
                    // Layout.preferredWidth: 100
                    source: model.thumb
                }

                Text {
                    Layout.columnSpan: 2

                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: model.name
                }

                // RowLayout {
                //     Layout.columnSpan: 2
                //     Layout.margins: 0
                //     Layout.fillWidth: false
                //     spacing: 0
                //     Repeater {
                //         model: 5
                //         Button {
                //             implicitWidth: 30
                //             implicitHeight: 30
                //             Layout.margins: 0
                //             icon.width: 20
                //             icon.height: 20
                //             icon.name: "cil-star"
                //             icon.color: "yellow"
                //             background: Rectangle {
                //                 color: "transparent"
                //             }
                //         }
                //     }
                // }

                // ToolButton {
                //     Layout.alignment: Qt.AlignBottom | Qt.AlignLeft
                //     icon.name: "cil-cart-plus"
                // }
                // Text {

                //     Layout.alignment: Qt.AlignVCenter | Qt.AlignRight

                //     horizontalAlignment: Text.AlignHCenter
                //     text: model.price
                // }
            }
        }
    }

}
