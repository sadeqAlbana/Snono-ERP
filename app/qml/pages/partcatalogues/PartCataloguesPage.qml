import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Palettes
import CoreUI.Impl
import PosFe
import CoreUI

AppPage {
    id: root
    title: qsTr("Parts Catalogues")

    property int catalogueId: 0
    property int sectionId: 0
    property string sectionFile: ""        // basename of the section diagram
    property var sectionsData: []

    function loadCatalogues() {
        Api.partCatalogues().subscribe(function (res) {
            var data = res.json("data")
            var list = []
            for (var i = 0; i < data.length; i++) {
                var brand = data[i].brand ? data[i].brand : ""
                var name = data[i].vehicle ? data[i].vehicle : data[i].name
                list.push({
                    "id": data[i].id,
                    "label": (brand + " " + name).trim()
                })
            }
            catalogueCombo.model = list
        })
    }

    function loadSections(catId) {
        root.sectionId = 0
        root.sectionFile = ""
        root.sectionsData = []
        if (catId <= 0)
            return
        Api.partCatalogueSections(catId).subscribe(function (res) {
            root.sectionsData = res.json("data")
            entriesModel.filter = {
                "catalogue_id": catId
            }
            entriesModel.requestData()
        })
    }

    function selectSection(section) {
        root.sectionId = section.id
        var ip = section.image_path ? section.image_path : ""
        root.sectionFile = ip.substring(ip.lastIndexOf("/") + 1)
        var f = entriesModel.filter
        f["catalogue_id"] = root.catalogueId
        f["section_id"] = section.id
        entriesModel.filter = f
        entriesModel.requestData()
    }

    Component.onCompleted: loadCatalogues()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            spacing: 10
            Label {
                text: qsTr("Model")
            }
            CComboBox {
                id: catalogueCombo
                Layout.preferredWidth: 320
                textRole: "label"
                valueRole: "id"
                model: []
                onCurrentValueChanged: {
                    root.catalogueId = currentValue === undefined ? 0 : currentValue
                    root.loadSections(root.catalogueId)
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }

        // Top: sections (left) + diagram (right). Bottom: the parts table.
        // A vertical SplitView reliably allocates height to both and lets the
        // user drag the divider.
        SplitView {
            orientation: Qt.Vertical
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                SplitView.fillWidth: true
                SplitView.preferredHeight: 320
                SplitView.minimumHeight: 160
                spacing: 10

                Frame {
                    Layout.preferredWidth: 340
                    Layout.fillHeight: true
                    padding: 2

                    ListView {
                        id: sectionsList
                        anchors.fill: parent
                        clip: true
                        model: root.sectionsData
                        ScrollBar.vertical: ScrollBar {}
                        delegate: ItemDelegate {
                            required property var modelData
                            width: ListView.view.width
                            highlighted: modelData.id === root.sectionId
                            text: (modelData.section_code ? modelData.section_code : "")
                                  + "  " + (modelData.section_name ? modelData.section_name : "")
                                  + "  (" + modelData.entries + ")"
                            onClicked: root.selectSection(modelData)
                        }
                    }
                }

                Frame {
                    id: diagramFrame
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    padding: 2

                    property real zoom: 1.0
                    readonly property real minZoom: 0.1
                    readonly property real maxZoom: 8.0

                    function fitZoom() {
                        if (diagram.implicitWidth <= 0 || diagram.implicitHeight <= 0)
                            return 1.0
                        return Math.min(flick.width / diagram.implicitWidth,
                                        flick.height / diagram.implicitHeight)
                    }
                    function fit() {
                        zoom = Math.max(minZoom, Math.min(maxZoom, fitZoom()))
                    }
                    function setZoom(z) {
                        zoom = Math.max(minZoom, Math.min(maxZoom, z))
                    }

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 4

                        // Zoom controls
                        RowLayout {
                            Layout.fillWidth: true
                            spacing: 2
                            enabled: diagram.status === Image.Ready
                            ToolButton {
                                text: "−"           // minus
                                onClicked: diagramFrame.setZoom(diagramFrame.zoom / 1.25)
                            }
                            ToolButton {
                                text: "+"
                                onClicked: diagramFrame.setZoom(diagramFrame.zoom * 1.25)
                            }
                            ToolButton {
                                text: qsTr("Fit")
                                onClicked: diagramFrame.fit()
                            }
                            ToolButton {
                                text: "1:1"
                                onClicked: diagramFrame.setZoom(1.0)
                            }
                            Label {
                                text: Math.round(diagramFrame.zoom * 100) + "%"
                                verticalAlignment: Text.AlignVCenter
                                opacity: 0.7
                            }
                            Item { Layout.fillWidth: true }
                        }

                        Flickable {
                            id: flick
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            clip: true
                            contentWidth: Math.max(width, diagram.width)
                            contentHeight: Math.max(height, diagram.height)
                            ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }
                            ScrollBar.horizontal: ScrollBar { policy: ScrollBar.AsNeeded }

                            Image {
                                id: diagram
                                width: implicitWidth * diagramFrame.zoom
                                height: implicitHeight * diagramFrame.zoom
                                // center while smaller than the viewport, else scroll
                                x: Math.max(0, (flick.width - width) / 2)
                                y: Math.max(0, (flick.height - height) / 2)
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                                cache: true
                                smooth: true
                                mipmap: true
                                source: (root.catalogueId > 0 && root.sectionFile !== "")
                                        ? (Settings.serverUrlString()
                                           + "/partcatalogue/image?catalogue_id=" + root.catalogueId
                                           + "&file=" + root.sectionFile)
                                        : ""
                                onStatusChanged: if (status === Image.Ready) diagramFrame.fit()
                            }

                            // Wheel to zoom (scrollbars / drag pan to navigate).
                            WheelHandler {
                                target: null
                                onWheel: event => {
                                             var f = event.angleDelta.y > 0 ? 1.15 : (1 / 1.15)
                                             diagramFrame.setZoom(diagramFrame.zoom * f)
                                         }
                            }
                        }
                    }

                    Label {
                        anchors.centerIn: parent
                        visible: diagram.source.toString() === "" || diagram.status !== Image.Ready
                        text: root.sectionId === 0 ? qsTr("Select a section to view its diagram")
                                                   : qsTr("No diagram")
                        opacity: 0.6
                    }
                }
            }

            ColumnLayout {
                SplitView.fillWidth: true
                SplitView.fillHeight: true
                SplitView.minimumHeight: 160
                spacing: 6

                AppToolBar {
                    id: toolBar
                    view: entriesView
                    onSearch: searchString => {
                                  var filter = entriesModel.filter
                                  filter['query'] = searchString
                                  entriesModel.filter = filter
                                  entriesModel.requestData()
                              }
                }

                CTableView {
                    id: entriesView
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    // Text columns use the default delegate; the "actions" column
                    // gets a per-row "Sources" button.
                    delegate: DelegateChooser {
                        role: "delegateType"
                        DelegateChoice {
                            roleValue: "action"
                            delegate: ActionsDelegate {
                                id: actCell
                                property var rec: entriesModel.recordAt(row)
                                property bool hasSources: rec && (rec.source_count > 0)
                                CButton {
                                    text: qsTr("Sources")
                                    Layout.alignment: Qt.AlignCenter
                                    // green when external sources exist, red when none
                                    palette: actCell.hasSources ? okPal : noPal
                                    onClicked: {
                                        var r = entriesModel.recordAt(row)
                                        sourcesDialog.openFor(r.part_id, r.part_number, r.description)
                                    }
                                    BrandSuccess { id: okPal }
                                    BrandDanger { id: noPal }
                                }
                            }
                        }
                        DelegateChoice {
                            delegate: CTableViewDelegate {}
                        }
                    }

                    model: PartEntriesModel {
                        id: entriesModel
                    }
                }
            }
        }
    }

    PartSourcesDialog {
        id: sourcesDialog
    }
}
