import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Expeses Report")
    delegate: AppDelegateChooser {}
    model: ExpensesReportModel{}

}
