import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Stock Reservations")
    delegate: AppDelegateChooser {
        DelegateChoice {
            roleValue: "ReservationStatus"
            StockReservationStatusDelegate {}
        }
    }
    model: StockReservationsModel{}
}
