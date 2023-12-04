import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import PosFe
AppPage{
    id: page
    StackView.onActivated: model.refresh();
    property var model;
    property var delegate;
    property list<CAction> actions;
    property var searchHandler: function(searchString){
        var filter=model.filter;
        filter['query']=searchString
        page.model.filter=filter;
        page.model.requestData();
    };

    property var filterHandler: function(filter){
        page.model.filter = filter;
        page.model.requestData();
    }
    property alias view: tableView

    ColumnLayout{
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            view: tableView
            onSearch:page.searchHandler(searchString)

            onFilterClicked: page.filterHandler(filter)


        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            delegate: page.delegate
            actions: page.actions
            model: page.model;
        }
    }
}

