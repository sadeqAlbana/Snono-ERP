import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl

import CoreUI
import PosFe
import QtPositioning
import QtLocation
import CoreUI.Palettes
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    fetchUrl: "/shipment"
    url: "/shipment/status"
    title: qsTr("Update Shipment Status")
    CLabel {
        text: qsTr("Shipment Number:")
    }
    CNumberInput {
        objectName: "id"
        enabled: false
        Layout.fillWidth: true
    }

    CLabel {
        text: qsTr("Status")
    }

    CComboBox {
        id: typeCB
        objectName: "status"
        Layout.fillWidth: true
        textRole: "text"
        valueRole: "status"
        model: ListModel {
            // ListElement {
            //     text: qsTr("Manifest Created")
            //     value: "manifest_created"
            // }
            // ListElement {
            //     text: qsTr("In Transit")
            //     value: "in_transit"
            // }
            // ListElement {
            //     text: qsTr("At Local Delivery Center")
            //     value: "at_local_delivery_center"
            // }
            ListElement {
                text: qsTr("Out For Delivery")
                status: "out_for_delivery"
            }
            ListElement {
                text: qsTr("Delivered")
                status: "delivered"
            }
            ListElement {
                text: qsTr("Returned")
                status: "returned"
            }
            ListElement {
                text: qsTr("Partially Returned")
                status: "partially_returned"
            }
            // ListElement {
            //     text: qsTr("Cancelled")
            //     value: "cancelled"
            // }
        }

    }

    MapView {
        id: view
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 2
        Layout.minimumWidth: Screen.width*0.7
        Layout.minimumHeight: Screen.height/2
        map.zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
        map.center {
            // The Qt Company in Oslo
            latitude: 59.9485
            longitude: 10.7686
        }
        map.plugin: Plugin {
            id: googleMaps
            name: "googlemaps" // "mapboxgl", "esri", ...
            // specify plugin parameters if necessary
             // PluginParameter {
             //     name:"googlemaps.maps.apikey"
             //     value:"AIzaSyAl4e5Qaf5mYadK_BH3G7721yEcgt_Xcu0"
             // }

             PluginParameter { name: "googlemaps.useragent"; value: "mygreatapp" }

             PluginParameter { name: "googlemaps.cachefolder"; value: "/gmaps_cache" }

             PluginParameter { name: "googlemaps.route.apikey"; value: "bla-bla" }

             PluginParameter { name: "googlemaps.maps.apikey"; value: "bla-bla1" }

             PluginParameter { name: "googlemaps.geocode.apikey"; value: "bla-bla2" }

             PluginParameter { name: "googlemaps.maps.tilesize"; value: "256" }
             // PluginParameter { name: "googlemaps.maps.mapType"; value: "terrain" }

        }

        CButton {
             id: currentLocationButton
             icon.name: "cis-location-gps-fixed"
             palette: BrandLight{}
             radius: 10
             width: 50
             height: 50
             display: Button.IconOnly
             anchors {
                 bottom: parent.bottom
                 right: parent.right
                 margins: 20
             }
             onClicked: {
                 if (view.map.visibleRegion.isValid) {
                     //view.map.center = view.map.visibleRegion.center
                     view.map.center=positionSource.position.coordinate
                     view.map.zoomLevel = 15
                 }
             }
         }

        PositionSource {
             id: positionSource
             active: true
             updateInterval: 1000 // Update interval in milliseconds

             onPositionChanged: {
                 console.log("Latitude:", position.coordinate.latitude, ", Longitude:", position.coordinate.longitude);
             }
         }
    }


}
