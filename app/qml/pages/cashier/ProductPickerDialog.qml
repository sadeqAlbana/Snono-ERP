import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Buttons
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppDialog {
    id: dialog
    title: qsTr("Pick a Product")

    signal productPicked(int productId)
    // richer variant: carries the full picked product (id, name, list_price, …) so
    // callers that need price/name don't have to re-fetch. Emitted alongside productPicked.
    signal productPickedObject(var product)

    width: Math.min(1100, (parent ? parent.width : 1000) * 0.9)
    height: Math.min(780, (parent ? parent.height : 700) * 0.9)

    background: Rectangle {
        color: "#ffffff"
        radius: 8
        border.color: "#d0d0d0"
        border.width: 1
    }

    onOpened: {
        searchField.text = ""
        var f = productsModel.filter
        f["query"] = ""
        productsModel.filter = f
        productsModel.requestData()
        searchField.forceActiveFocus()
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Text {
                text: dialog.title
                font.pixelSize: 20
                font.weight: Font.DemiBold
                Layout.fillWidth: true
            }

            CButton {
                text: qsTr("Done")
                palette.button: "#2eb85c"
                palette.buttonText: "#ffffff"
                implicitHeight: 40
                onClicked: dialog.close()
            }
        }

        CIconTextField {
            id: searchField
            Layout.fillWidth: true
            implicitHeight: 50
            placeholderText: qsTr("Search products...")
            rightIcon.name: "cil-search"
            font.pixelSize: 16

            onTextChanged: searchDebounce.restart()
            onEntered: searchDebounce.triggered()

            Timer {
                id: searchDebounce
                interval: 250
                repeat: false
                onTriggered: {
                    var f = productsModel.filter
                    f["query"] = searchField.text
                    productsModel.filter = f
                    productsModel.requestData()
                }
            }
        }

        GridView {
            id: grid
            Layout.fillWidth: true
            Layout.fillHeight: true
            cellWidth: 210
            cellHeight: 280
            clip: true

            model: ProductsModel {
                id: productsModel
                filter: ({"only_variants": true})
            }

            ScrollBar.vertical: ScrollBar { active: true }

            delegate: ItemDelegate {
                id: card
                width: grid.cellWidth - 10
                height: grid.cellHeight - 10
                hoverEnabled: true

                background: Rectangle {
                    color: card.hovered ? "#eef6ff" : "#ffffff"
                    border.color: card.hovered ? "#3399ff" : "#d0d0d0"
                    border.width: 1
                    radius: 6
                }

                onClicked: {
                    dialog.productPicked(model.id)
                    dialog.productPickedObject({"id": model.id, "name": model.name ?? "",
                                                "list_price": model.list_price ?? 0})
                    dialog.close()
                }

                contentItem: ColumnLayout {
                    spacing: 6
                    anchors.fill: parent
                    anchors.margins: 6

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 150

                        LoadingImage {
                            anchors.fill: parent
                            visible: model.thumb !== undefined && model.thumb !== null && String(model.thumb).length > 0
                            cache: true
                            antialiasing: true
                            fillMode: Image.PreserveAspectFit
                            source: model.thumb ?? ""
                        }

                        Rectangle {
                            anchors.fill: parent
                            visible: !(model.thumb !== undefined && model.thumb !== null && String(model.thumb).length > 0)
                            color: "#f4f4f4"
                            radius: 4
                            border.color: "#e0e0e0"
                            border.width: 1

                            Image {
                                anchors.centerIn: parent
                                width: 48
                                height: 48
                                source: "qrc:/icons/CoreUI/free/cil-image.svg"
                                fillMode: Image.PreserveAspectFit
                                opacity: 0.5
                            }
                        }
                    }

                    Text {
                        text: model.name ?? ""
                        elide: Text.ElideRight
                        wrapMode: Text.WordWrap
                        maximumLineCount: 2
                        font.weight: Font.DemiBold
                        font.pixelSize: 14
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    Text {
                        text: Utils.formatCurrency(model.list_price ?? 0)
                        font.weight: Font.DemiBold
                        font.pixelSize: 14
                        color: "#2eb85c"
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }
    }
}
