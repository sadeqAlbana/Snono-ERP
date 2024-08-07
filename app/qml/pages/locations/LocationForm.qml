import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
import QtPositioning
import QtLocation
CFormView {
    id: control
    padding: 10
    rowSpacing: 25
    header.visible: true
    url: "/location"
    columns: 4
    CLabel {
        text: qsTr("Name")
        Layout.row:0
        Layout.column: 0
        Layout.bottomMargin: -control.rowSpacing
    }
    CTextField {
        objectName: "name"
        Layout.fillWidth: true
        placeholderText: qsTr("Name...")
        Layout.row:1
        Layout.column: 0
    }

    CLabel {
        text: qsTr("Country")
        Layout.row:0
        Layout.column: 1
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {
        objectName: "country"
        Layout.fillWidth: true
        Layout.row:1
        Layout.column: 1
    }

    CLabel {
        text: qsTr("Province")
        Layout.row:0
        Layout.column: 2
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {

        objectName: "province"
        Layout.fillWidth: true
        Layout.row:1
        Layout.column: 2
    }

    CLabel {
        text: qsTr("City")
        Layout.row:0
        Layout.column: 3
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {

        objectName: "city"
        Layout.fillWidth: true
        Layout.row:1
        Layout.column: 3
    }

    CLabel {
        text: qsTr("District")
        Layout.row:2
        Layout.column: 0
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {

        objectName: "district"
        Layout.fillWidth: true
        Layout.row:3
        Layout.column: 0
    }

    CLabel {
        text: qsTr("Post Code")
        Layout.row:2
        Layout.column: 1
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {
        objectName: "postcode"
        Layout.fillWidth: true
        Layout.row:3
        Layout.column: 1
    }

    CLabel {
        text: qsTr("Building")
        Layout.row:2
        Layout.column: 2
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {

        objectName: "building"
        Layout.fillWidth: true
        Layout.row:3
        Layout.column: 2
    }

    CLabel {
        text: qsTr("Floor")
        Layout.row:2
        Layout.column: 3
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {

        objectName: "floor"
        Layout.fillWidth: true
        Layout.row:3
        Layout.column: 3
    }

    CLabel {
        text: qsTr("Apartment")
        Layout.row: 4
        Layout.column: 0
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {
        objectName: "apartment"
        Layout.fillWidth: true
        Layout.row: 5
        Layout.column: 0
    }

    CLabel {
        text: qsTr("Phone")
        Layout.row: 4
        Layout.column: 1
        Layout.bottomMargin: -control.rowSpacing
    }

    CTextField {
        objectName: "phone"
        Layout.fillWidth: true
        Layout.row: 5
        Layout.column: 1
    }

    CLabel {
        text: qsTr("First Name")
        Layout.row:4
        Layout.column: 2
        Layout.bottomMargin: -control.rowSpacing
    }
    CTextField {
        objectName: "first_name"
        Layout.fillWidth: true
        placeholderText: qsTr("First Name...")
        Layout.row:5
        Layout.column: 2
    }

    CLabel {
        text: qsTr("Last Name")
        Layout.row:4
        Layout.column: 3
        Layout.bottomMargin: -control.rowSpacing
    }
    CTextField {
        objectName: "last_name"
        Layout.fillWidth: true
        placeholderText: qsTr("Last Name...")
        Layout.row:5
        Layout.column: 3
    }


    CLabel {
        text: qsTr("Details")
        Layout.row: 6
        Layout.column: 0
        Layout.bottomMargin: -control.rowSpacing
    }


    CTextArea {
        objectName: "details"
        Layout.fillWidth: true
        Layout.row: 7
        Layout.columnSpan: control.columns
    }

    TextField{
        objectName: "lo"
        visible: false
        text: view.map.center.longitude
    }
    TextField{
        objectName: "la"
        visible: false
        text: view.map.center.latitude
    }


    MapView {
        id: view
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.columnSpan: 4
        Layout.minimumWidth: 400
        Layout.minimumHeight: 600
        map.zoomLevel: (maximumZoomLevel - minimumZoomLevel)/2
        map.center {
            // The Qt Company in Oslo
            latitude: 59.9485
            longitude: 10.7686
        }

        // map.activeMapType: map.supportedMapTypes[map.supportedMapTypes.length - 1]
        // map.plugin: Plugin {
        //     name: "osm"

        //     PluginParameter {
        //         name: "osm.mapping.custom.host"

        //         // OSM plugin will auto-append if .png isn't suffix, and that screws up apikey which silently
        //         // fails authentication (only Wireshark revealed it)
        //         value: "http://tile.thunderforest.com/landscape/%z/%x/%y.png?apikey=2759c68bec6e42dc8317e23919289d24&fake=.png"
        //     }
        //     //specify plugin parameters if necessary
        //     //PluginParameter {...}
        //     //PluginParameter {...}
        //     //...
        // }



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

        Button {
             id: currentLocationButton
             text: "Current Location"
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
