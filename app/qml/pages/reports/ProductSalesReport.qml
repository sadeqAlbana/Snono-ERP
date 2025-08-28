import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Product Sales")
    delegate: AppDelegateChooser {}
    model: ProductSalesReportModel{}
    advancedFilter:  [
        {"type": "date","label": qsTr("from"),"key": "from"},
        {"type": "date","label": qsTr("to"),"key": "to"}

    ]
    actions: [
        CAction{ text: qsTr("Print"); icon.name: "cil-print"; onTriggered: model.print()}
    ]
}
