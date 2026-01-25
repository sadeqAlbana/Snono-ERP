import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Forms
import CoreUI.Base
import QtQuick.Layouts
import CoreUI
CFormView {
    id: control
    padding: 10
    rowSpacing: 30
    url: "/owner"
    title: qsTr("Owners")
    CLabel {
        text: qsTr("Owner")
    }
    CFilterComboBox {
        Layout.fillWidth: true
        objectName: "owner_id"
        textRole: "name"
        valueRole: "id"
        dataUrl: "/owners/list"
    } //end categoryCB


    CLabel {
        text: qsTr("Amount")
    }
    CNumberInput {
        objectName: "amount"
        Layout.fillWidth: true
    }

    CLabel{
        text: qsTr("Liquidity Account");
    }
    CFilterComboBox {
        Layout.fillWidth: true
        objectName: "dst_account_id"
        textRole: "name"
        valueRole: "id"
        dataUrl: "/accounts/list?=type=liquidity"
    } //end categoryCB

}
