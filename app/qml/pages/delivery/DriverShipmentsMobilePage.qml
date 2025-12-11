import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import CoreUI
import CoreUI.Palettes
AppPage{
    title: qsTr("My Shipments")
    padding: 10
    background: Rectangle{
        color: "transparent"
    }

    ColumnLayout{
        id: page
        anchors.fill: parent;
        spacing: 10


        RowLayout{
            CButton{
                icon.name: "cil-qr-code"
                icon.color: "#fff"
                palette: BrandInfo{}
                display: Button.IconOnly
                Layout.preferredHeight: 50
                onClicked: {
                    let qrPage=Router.navigate("qrc:/PosFe/qml/common/ScanQrPage.qml",{},null)
                        qrPage.captured.connect(function(text){
                        search.text=text;
                        Router.back();


                            /*

{
                                 "title": qsTr("Edit"),
                                 "keyValue": page.model.jsonObject(
                                                 page.view.currentRow).id
                             }
*/
                        let shipment=model.findShipment(parseInt(text))
                        Router.navigate("qrc:/PosFe/qml/pages/delivery/UpdateShipmentStatusMobilePage.qml",{
                                        "keyValue": shipment.id}
                                            );
                        });


                }
            }
            CIconTextField{
                id: search
                Layout.preferredHeight: 50
                Layout.preferredWidth: 300
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                font.pixelSize: 18
                placeholderText: qsTr("Search...")
                rightIcon.name: "cil-search"

                onEntered: () => {
                    var filter=model.filter;
                    filter['query']=search.text
                    model.filter=filter;
                    model.requestData();
                }
            }//search
        }



        ListView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            delegate: ItemDelegate{

            width: tableView.width
                contentItem: ColumnLayout{
                    Text{
                        text: "#"+model.id
                        font.bold: true
                        font.pixelSize: 25
                    }

                    Badge{
                        id: badge
                        width: 200
                        height: 30
                        text: switch (model.status) {
                            case "manifest_created":        return qsTr("Manifest Created");
                            case "in_transit":              return qsTr("In Transit");
                            case "at_local_delivery_center":return qsTr("At Local Delivery Center");
                            case "out_for_delivery":        return qsTr("Out for Delivery");
                            case "delivered":               return qsTr("Delivered");
                            case "returned":                return qsTr("Returned");
                            case "partially_returned":      return qsTr("Partially Returned");
                            case "cancelled":               return qsTr("Cancelled");
                            default: return "N.A";
                        }

                        state: switch (model.status) {
                            case "manifest_created":        return "info";
                            case "in_transit":              return "secondary";
                            case "at_local_delivery_center":return "warning";
                            case "out_for_delivery":        return "primary";
                            case "delivered":               return "success";
                            case "returned":                return "danger";
                            case "partially_returned":      return "danger";
                            case "cancelled":               return "danger";
                            default: return "Invalid";
                        }
                        }

                    Text{
                        font.pixelSize: 20
                        text: "<b>"+qsTr("Recipient:")+"</b> " + model["dst_address.first_name"]
                    }
                    Text{
                        textFormat: Text.RichText
                        text: "<b>"+qsTr("Phone:")+"</b> " + "<a href=tel:"+model["dst_address.phone"]+">"+model["dst_address.phone"]+ "</a>"
                        onLinkActivated: Qt.openUrlExternally("tel:"+model["dst_address.phone"])
                        palette: BrandPrimary{}
                        font.pixelSize: 20

                    }
                    Text{
                        font.pixelSize: 20
                        text: "<b>"+qsTr("Address:")+"</b> " +
                              model["dst_address.district"]
                    }

                    RowLayout{
                        Layout.topMargin: 15
                        CPillButton{
                            text: qsTr("View Details")
                            palette.button: "#e2eaed"
                            palette.buttonText: "#1881dd"
                            font.weight: Font.DemiBold
                            Layout.alignment: Qt.AlignCenter
                        }
                        HorizontalSpacer{}
                        CPillButton{
                            text: qsTr("Update Status")
                            palette.button: "#e2eaed"
                            palette.buttonText: "#1881dd"
                            font.weight: Font.DemiBold
                            Layout.alignment: Qt.AlignCenter
                            enabled: !["manifest_created", "in_transit"].includes(model.status)
                            onClicked: {
                                Router.navigate("qrc:/PosFe/qml/pages/delivery/UpdateShipmentStatusMobilePage.qml",{
                                                "keyValue": model.id}
                                                    );
                            }

                        }
                    }
                }

            background: Rectangle{
                border.color: badge.color
                radius: CoreUI.borderRadius
                border.width: 2
            }


            }


            model: ShipmentsModel{
                id: model
                filter: {"user_id":AuthManager.user.id}
            }//model

        }//listView




    }//layout

}

