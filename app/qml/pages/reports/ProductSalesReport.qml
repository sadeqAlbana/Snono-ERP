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
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;

        spacing: 10
        AppToolBar{
            id: toolBar
            tableView: tableView
            searchVisible: false

            CTextField{
                id: fromTF
                text: "2022-01-01"
                inputMask: "0000-00-00"

            }
            CTextField{
                id: toTF
                text: "2022-10-01"
                inputMask: "0000-00-00"
            }

            CButton{
                palette: BrandInfo{}
                text: qsTr("Apply")
                onClicked: model.requestData();

            }

        }

        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true

            delegate: AppDelegateChooser{}

            actions: [
                Action{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
            ]
            model: ProductSalesReportModel{
                id: model
                filter: {
                    "from": fromTF.text,
                    "to": toTF.text
                }
                Component.onCompleted: requestData();

            }//model

        }
    }
}

