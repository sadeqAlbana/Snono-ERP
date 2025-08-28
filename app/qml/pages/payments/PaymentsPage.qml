import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Payments")
    delegate: AppDelegateChooser {
         DelegateChoice {
             roleValue: "PaymentStatusDelegate"
             PaymentStatusDelegate {}
         }
     }
    model: PaymentsModel{}
}
