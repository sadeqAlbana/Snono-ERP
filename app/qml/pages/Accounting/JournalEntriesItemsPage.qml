import QtQuick;
import QtQuick.Layouts
import QtQuick.Controls.Basic;

import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils


import  PosFe

AppPage{

    title: qsTr("Journal Entries Items")
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


            delegate: AppDelegateChooser{
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }

            model: JournalEntriesItemsModel{
                id: model;



            } //model end

        }
    }
}

