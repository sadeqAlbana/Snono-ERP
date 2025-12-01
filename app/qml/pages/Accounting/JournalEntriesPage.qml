import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import PosFe

AppPage {
    title: qsTr("Journal Entries")
    ColumnLayout {
        id: page
        anchors.fill: parent
        AppToolBar {
            id: toolBar
            view: tableView

            onSearch: searchString => {
                          var filter = model.filter
                          filter['query'] = searchString
                          model.filter = filter
                          model.requestData()
                      }
        }
        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser {
                DelegateChoice {
                    roleValue: "JournalEntryStatus"
                    JournalEntryStatusDelegate {}
                }
            }

            actions: [
                CAction {
                    text: qsTr("New")
                    icon.name: "cil-plus"
                    onTriggered: {
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/Accounting/NewJournalEntryPage.qml")
                    }
                },
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Confirm")
                    icon.name: "cil-check"
                    onTriggered: {
                        Api.post("journalEntry/updateStatus", {"id":model.data(
                                                                        tableView.currentRow,
                                                                        "id"),"status":"posted"}).subscribe(function (response) {
                                         if (response.json("status") === 200) {
                                             model.refresh()
                                         }
                                     })
                    }
                },
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Cancel")
                    icon.name: "cil-delete"
                    onTriggered: {
                        Api.post("journalEntry/updateStatus", {"id":model.data(
                                                                        tableView.currentRow,
                                                                        "id"),"status":"cancelled"}).subscribe(function (response) {
                                         if (response.json("status") === 200) {
                                             model.refresh()
                                         }
                                     })
                    }
                },
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Details")
                    icon.name: "cil-notes"
                    onTriggered: {
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/Accounting/JournalEntryDetailsPage.qml",
                                    {
                                        "keyValue": model.jsonObject(
                                                        tableView.currentRow).id
                                    })
                    }
                }
            ]
            model: JournalEntriesModel {
                id: model
            } //model end
        }
    }
}
