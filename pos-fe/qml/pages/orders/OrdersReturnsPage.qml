import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt.labs.qmlmodels 1.0
import Qt5Compat.GraphicalEffects
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"
import App.Models 1.0

AppPage{

    title: qsTr("Orders Returns")
    padding: 15
    ColumnLayout{
        id: page
        anchors.fill: parent;

        AppToolBar{
            id: toolBar
            tableView: tableView

            onSearch: {
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
            }

            actions: [
                //Action{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: {}},
                //Action{ text: qsTr("Delete"); icon.name: "cil-delete"; onTriggered: {}}
            ]

            model: OrdersReturnsModel{
                id: model

            }//model end
        }//tableview end
    }//ColumnLayout end
}//card end

