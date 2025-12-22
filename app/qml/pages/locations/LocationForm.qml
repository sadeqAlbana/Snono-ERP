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
import Qt5Compat.GraphicalEffects

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
        id: lo
        objectName: "lo"
        visible: false
        text: view.map.center.longitude
    }
    TextField{
        id: la
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
            latitude: la.text
            longitude: lo.text
        }
        map.plugin: Plugin {
            id: googleMaps
            name: "googlemaps" // "mapboxgl", "esri", ...
            // specify plugin parameters if necessary
            PluginParameter {
                name:"googlemaps.maps.apikey"
                value:"AIzaSyA_k-Zq6hBO7hFMWpd5vdsZYT-mLgCvdmo"
            }

             PluginParameter { name: "googlemaps.useragent"; value: "mygreatapp" }

             PluginParameter { name: "googlemaps.cachefolder"; value: "/gmaps_cache" }

             PluginParameter { name: "googlemaps.route.apikey"; value: "bla-bla" }

             PluginParameter { name: "googlemaps.maps.apikey"; value: "bla-bla1" }

             PluginParameter { name: "googlemaps.geocode.apikey"; value: "bla-bla2" }

             PluginParameter { name: "googlemaps.maps.tilesize"; value: "256" }
             // PluginParameter { name: "googlemaps.maps.mapType"; value: "terrain" }

        }

        MapQuickItem {
            id: userMarker
            anchorPoint.x: icon.width / 2
            anchorPoint.y: icon.height
            coordinate {
                    latitude: la.text
                    longitude: lo.text
                }


            sourceItem: Image {
                id: icon
                source: "qrc:/images/icons/location-pin.svg"

                width: 32
                height: 32

                ColorOverlay {
                    anchors.fill: icon
                    source: icon
                    color: "#ff0000"  // make image like it lays under red glass
                }

            }

            Component.onCompleted: view.map.addMapItem(userMarker)
        }
    }// end map

}
