import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import App.Models 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"
import "qrc:/CoreUI/palettes"

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

