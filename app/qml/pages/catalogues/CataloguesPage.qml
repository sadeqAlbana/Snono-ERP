import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Qt.labs.qmlmodels
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage {
    id: root
    title: qsTr("External Catalogues")

    // current source filter (0 = all sources)
    property int sourceId: 0

    function loadSources() {
        Api.catalogueSources().subscribe(function (res) {
            var sources = [{
                "id": 0,
                "name": qsTr("All sources")
            }]
            var data = res.json("data")
            for (var i = 0; i < data.length; i++)
                sources.push({
                    "id": data[i].id,
                    "name": data[i].name
                })
            sourceCombo.model = sources
        })
    }

    Component.onCompleted: loadSources()

    ColumnLayout {
        id: page
        anchors.fill: parent
        spacing: 10

        AppToolBar {
            id: toolBar
            view: tableView
            onSearch: searchString => {
                          var filter = tableModel.filter
                          filter['query'] = searchString
                          tableModel.filter = filter
                          tableModel.requestData()
                      }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 10

            Label {
                text: qsTr("Source")
            }
            CComboBox {
                id: sourceCombo
                Layout.preferredWidth: 280
                textRole: "name"
                valueRole: "id"
                model: [{
                        "id": 0,
                        "name": qsTr("All sources")
                    }]
                onCurrentValueChanged: {
                    root.sourceId = currentValue === undefined ? 0 : currentValue
                    var filter = tableModel.filter
                    filter['source_id'] = root.sourceId
                    tableModel.filter = filter
                    tableModel.requestData()
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }

        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser {}
            permissionProvider: function (permission) {
                return AuthManager.hasPermission(permission)
            }

            actions: [
                CAction {
                    text: qsTr("Refresh")
                    icon.name: "cil-reload"
                    onTriggered: tableModel.requestData()
                },
                CAction {
                    text: qsTr("Sync now")
                    icon.name: "cil-cloud-download"
                    permission: "prm_sync_catalogues"
                    onTriggered: {
                        Api.syncCatalogues(root.sourceId).subscribe(function (res) {
                            var j = res.json()
                            toastrService.push(qsTr("Catalogue"),
                                               j.message || qsTr("Sync started"),
                                               j.status === 200 ? "success" : "error",
                                               3000)
                        })
                    }
                },
                CAction {
                    text: qsTr("Open Link")
                    icon.name: "cil-external-link"
                    enabled: tableView.currentRow >= 0
                    onTriggered: {
                        var url = tableModel.data(tableView.currentRow, "url")
                        if (url)
                            Qt.openUrlExternally(url)
                    }
                }
            ]

            model: CataloguesModel {
                id: tableModel
            }
        }
    }
}
