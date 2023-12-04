import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils

import CoreUI.Palettes
import PosFe
AppPage{
    title: qsTr("Products")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            view: tableView
            searchVisible: true

            advancedFilter:  [
                {"type": "date","label": qsTr("from"),"key": "from"},
                {"type": "date","label": qsTr("to"),"key": "to"}

            ]

            onFilterClicked: (filter) => {
                                 model.filter=filter
                                 model.requestData();
                             }

            onSearch: searchString => {
                          var filter = model.filter
                          filter['query'] = searchString
                          model.filter = filter
                          model.requestData()
                      }


        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser{}

            actions: [
                CAction{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
            ]
            model: ProductSalesReportModel{
                id: model



            }//model

        }
    }
}

