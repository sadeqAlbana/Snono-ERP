import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt.labs.qmlmodels 1.0
import Qt5Compat.GraphicalEffects
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import CoreUI
AppPage{

    title: qsTr("Orders Returns")
    ColumnLayout{
        id: page
        anchors.fill: parent;

        AppToolBar{
            id: toolBar
            view: tableView

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
                CAction {
                    enabled: tableView.currentRow >= 0
                    text: qsTr("Details")
                    icon.name: "cil-notes"
                    onTriggered: {
                        Router.navigate(
                                    "qrc:/PosFe/qml/pages/orders/OrderReturnDetailsPage.qml",
                                    {
                                        "keyValue": model.jsonObject(
                                                        tableView.currentRow).id
                                    })
                    }
                }
            ]

            model: OrdersReturnsModel{
                id: model

            }//model end
        }//tableview end
    }//ColumnLayout end
}//card end

