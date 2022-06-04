import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import App.Models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"

Card{
    title: qsTr("Products")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10


        AppToolBar{
            id: toolBar
            tableView: tableView
            onSearch: (searchString) => {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }
        }


        ListView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            delegate: ItemDelegate{
                id: control
                icon.source: model.thumb
                width: ListView.view.width
                height: 120
                implicitHeight: 120
                icon.color: "transparent"
                icon.cache: true
                text: model.sku
                spacing: 10
                property var stock: model["products_stocks.qty"]? model["products_stocks.qty"]: 0
                property string name: model.name

                contentItem: RowLayout{
                    spacing: control.spacing
                    Image{
                        id: image
                        //Layout.preferredHeight: 120
                        Layout.fillHeight: true
//                        Layout.preferredWidth: height*1.375
                        smooth: true
                        cache: true
                        horizontalAlignment: Image.AlignHCenter
                        verticalAlignment: Image.AlignVCenter
                        antialiasing: true
                        fillMode: Image.PreserveAspectFit
                        source: model.thumb

                        BusyIndicator{
                            running: image.status===Image.Loading
                            anchors.fill: parent;
                            width: 55
                            height: 55
                        }
                    }
                    ColumnLayout{
                        Text{
                            font.family: "roboto"
                            color: "#000000";
                            text: control.text
                            font.pixelSize: metrics.font.pixelSize*1.2
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                        }
                        Text{
                            font.family: "roboto"
                            //color: control.palette.mid
                            text: control.name
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                        }
                        Text{
                            font.family: "roboto"
                            //color: "#A0A0A0"
                            text: control.stock
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                    }

                    Item{
                        Layout.fillWidth: true
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

