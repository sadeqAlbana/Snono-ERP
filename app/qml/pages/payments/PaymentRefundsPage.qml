import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
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
    title: qsTr("Payment Refunds")
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
            actions: []

            model: PaymentRefundsModel{
                id: model;
            } //model end
        }
    }
}

