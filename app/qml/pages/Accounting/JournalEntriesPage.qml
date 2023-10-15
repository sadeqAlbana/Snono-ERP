import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils


import  PosFe
AppPage{
    title: qsTr("Journal Entries")
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            view: tableView

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

        }
        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
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
                }]
            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }
            model: JournalEntriesModel{
                id: model;
            } //model end
        }
    }
}

