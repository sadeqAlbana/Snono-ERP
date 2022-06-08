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
                height: 120
                implicitHeight: 120
                icon.color: "transparent"
                icon.cache: true
                text: model.sku
                spacing: 10
                property var stock: model["products_stocks.qty"]? model["products_stocks.qty"]: 0
                property string name: model.name

                contentItem: RowLayout{
                    spacing: 0
                    Image{
                        id: image
                        //Layout.preferredHeight: 120
                        Layout.fillHeight: true
                        Layout.fillWidth: false
                        smooth: true
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
                            font.family: "roboto"
                            color: "#000000";
                            text: control.text
                            font.pixelSize: metrics.font.pixelSize*1.2
                            font.weight: Font.Medium
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true

                        }
                        Text{
                            font.family: "roboto"
                            //color: control.palette.mid
                            text: control.name
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            Layout.fillWidth: true


                        }
                        Text{
                            font.family: "roboto"
                            //color: "#A0A0A0"
                            text: control.stock
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
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

