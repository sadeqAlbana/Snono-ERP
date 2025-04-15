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



        model: ProductsDemoModel{
             filter: {"parentage":["have_variants","variantless"]}

        }

        cellWidth: 400
        cellHeight: 500


        delegate: Card{
            GridLayout {
                columns: 1
                anchors.fill: parent
                // Image {
                //     Layout.alignment: Qt.AlignCenter
                //     Layout.maximumWidth: 300
                //     fillMode: Image.PreserveAspectFit
                //     // Layout.preferredWidth: 100
                //     source: model.thumb
                // }

                // Text {

                //     Layout.alignment: Qt.AlignCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     text: model.name

                //     // Component.onCompleted: console.log(JSON.stringify(model))
                // }

                GridLayout{

                    Repeater{
                        model: model.sizes_stocks
                        ToolButton{
                            text: modelData.size
                            palette.button: modelData.qty? "green" : "red"
                        }
                    }


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
                //     Layout.alignment: Qt.AlignCenter
                //     horizontalAlignment: Text.AlignHCenter
                //     text: Utils.formatCurrency(model.list_price)
                // }
            }
        }
    }

}
