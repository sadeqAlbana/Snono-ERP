import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Stock Moves")
    delegate: AppDelegateChooser {}
    model: StockMovesModel{}
}
