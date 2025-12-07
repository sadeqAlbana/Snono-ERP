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
                            text: switch(model.status){
                                  case "manifest_created": return qsTr("Manifest Created");
                                  case "in_transit": return qsTr("In Transit");
                                  case "out_for_delivery": return qsTr("Out for Delivery");
                                  case "deliviered": return qsTr("Deliviered");
                                  default: return "N.A";
                                  }
                            state: switch(model.status){
                                   case "manifest_created": return "info";
                                   case "in_transit": return "secondary";
                                   case "out_for_delivery": return "primary";
                                   case "deliviered": return "success";

                                   default: return "Invalid";
                                   }
                        }

                    Text{
                        text: qsTr("<b>Recipient: </b>") + model["dst_address.first_name"]
                    }
                    Text{
                        text: qsTr("<b>Phone: </b>") + model["dst_address.phone"]
                    }
                    Text{
                        text: qsTr("<b>Address: </b>") +
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

