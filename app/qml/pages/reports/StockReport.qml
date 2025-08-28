import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Stock Report")
    delegate: AppDelegateChooser {}
    model: StockReportModel{}
    actions: [
        CAction{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
    ]
}
