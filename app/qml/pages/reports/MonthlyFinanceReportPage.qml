import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Monthly Finance")
    delegate: AppDelegateChooser {}
    model: MonthlyFinanceModel{}
}
