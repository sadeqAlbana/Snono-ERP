import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt5Compat.GraphicalEffects
import CoreUI
import PosFe
import Qt.labs.qmlmodels 1.0

AppPage {
    title: qsTr("Devices")
    id: page
    ;

    ColumnLayout {
        id: layout
        anchors.fill: parent
        AppToolBar {
            id: toolBar
            view: tableView

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }
        }

        CTableView {
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true



            delegate: AppDelegateChooser {

            }

            model: PosMachinesModel {
                id: model

            } //model end
        }
    }
}
