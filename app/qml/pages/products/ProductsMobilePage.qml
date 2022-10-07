import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage{
    title: qsTr("Products")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        spacing: 10




        CTextField{
            id: search
            Layout.preferredHeight: 50
            Layout.preferredWidth: 300
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: 18
            placeholderText: qsTr("Search...")
            rightIcon: "cil-search"

            onEntered: () => {
                var filter=model.filter;
                filter['query']=search.text
                model.filter=filter;
                model.requestData();
            }
        }//search



        ListView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            delegate: ItemDelegate{
                id: control
                icon.source: model.thumb
                width: ListView.view.width
                height: 140
                implicitHeight: 140
                icon.color: "transparent"
                icon.cache: true
                text: model.sku
                spacing: 10
                property var stock: model["products_stocks.qty"]? model["products_stocks.qty"]: 0
                property string name: model.name
                property real listPrice: model.list_price

                contentItem: RowLayout{
                    spacing: 30
                    Image{
                        id: image
                        //Layout.preferredHeight: 120
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        cache: true
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        source: model.thumb
                        Layout.preferredWidth: 80

                        BusyIndicator{
                            running: image.status===Image.Loading
                            anchors.fill: parent;
                            width: 55
                            height: 55
                        }


                    }
                    ColumnLayout{
                        Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                        Text{
                            color: "#000000";
                            text: control.text
                            font.pixelSize: metrics.font.pixelSize*1.3
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true

                        }
                        Text{
                            //color: control.palette.mid
                            text: control.name
                            font.weight: Font.DemiBold
                            font.pixelSize: metrics.font.pixelSize*1.3

                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true


                        }
                        Text{
                            //color: "#A0A0A0"
                            text: control.stock
                            font.pixelSize: metrics.font.pixelSize*1.3

                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true

                        }

                        Text{
                            //color: "#A0A0A0"
                            font.pixelSize: metrics.font.pixelSize*1.3

                            text: Utils.formatCurrency(control.listPrice)
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignLeft
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true

                        }

                    }



                }//contentItem
            }

            Rectangle{
                width: parent.width
                height: 1
                color: "#000000"
                opacity: 0.17
                anchors.bottom: parent.bottom
            }//delegate
            model: ProductsModel{
                id: model
                filter: {"only_variants":true}
                Component.onCompleted: requestData();
            }//model

        }//listView




    }//layout

}

