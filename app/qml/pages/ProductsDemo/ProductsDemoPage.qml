import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
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
        id: view


        anchors.horizontalCenter: parent.horizontalCenter
        width: {
            if (count === 0)
                return cellWidth; // fallback to prevent zero width

            let columns = Math.min(count, Math.floor(parent.width / cellWidth));
            return columns * cellWidth;
        }
        height: parent.height
        model: ProductsDemoModel{
             filter: {"parentage":["have_variants","variantless"]}

        }

        cellWidth: 300
        cellHeight: 500

        Popup{
            id: popup
            width: parent.width
            closePolicy: Popup.CloseOnPressOutside
            anchors.centerIn: parent

            contentItem: Image{
                id: popupImage;
                fillMode: Image.PreserveAspectFit
                width: sourceSize.width
            }
        }

        delegate: Card{

            GridLayout {
                id: grid
                columns: 1
                anchors.fill: parent

                property var sizes: model.sizes_stocks
                Image {
                    Layout.alignment: Qt.AlignCenter
                    Layout.maximumWidth: 300
                    fillMode: Image.PreserveAspectFit
                    // Layout.preferredWidth: 100
                    source: model.thumb?? ""

                    MouseArea{
                        anchors.fill: parent;
                        onClicked: {
                            popupImage.source=model.thumb
                            popup.open();
                        }
                    }
                }

                Text {

                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: model.name

                    // Component.onCompleted: console.log(JSON.stringify(model))
                }

                GridLayout{
                    Layout.alignment: Qt.AlignCenter
                    Repeater{
                        model: grid.sizes
                        CButton{
                            radius: height
                            text: modelData.size
                            palette.button: modelData.qty? CoreUI.success : CoreUI.danger
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
                Text {
                    Layout.alignment: Qt.AlignCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.DemiBold
                    text: Utils.formatCurrency(model.list_price)
                }
            }
        }
    }

}
