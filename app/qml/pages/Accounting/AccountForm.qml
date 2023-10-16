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
    header.visible: true
    url: "/account"
    columns: 2
    title: qsTr("Account")
    CLabel {
        text: qsTr("Name")
    }
    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "name"
        Layout.fillWidth: true
    }
    //    case "receivable": return qsTr("Receivable");
    //    case "payable": return qsTr("Payable");
    //    case "liquidity": return qsTr("Liquidity");
    //    case "other": return qsTr("Other");

    CLabel {
        text: qsTr("Type")
    }
    CComboBox {
        id: typeCB
        objectName: "type"
        Layout.fillWidth: true
        model: [
            {"label":qsTr("Receivable"), "value": "receivable"},
            {"label":qsTr("Payable"), "value": "payable"},
            {"label":qsTr("Liquidity"), "value": "liquidity"},
            {"label":qsTr("Other"), "value": "other"},
//            {"label":qsTr("Equity"), "value": "equity"},
        ]
        valueRole: "value"
        textRole: "label"
    }

    CLabel {
        text: qsTr("Internal Type")
    }
    CComboBox {
        id: internalTypeCB
        objectName: "internal_type"
        Layout.fillWidth: true
        model: [
            {"label":qsTr("Asset"), "value": "asset"},
            {"label":qsTr("Liability"), "value": "liability"},
            {"label":qsTr("Income"), "value": "income"},
            {"label":qsTr("Expense"), "value": "expense"},
//            {"label":qsTr("Equity"), "value": "equity"},
        ]
        valueRole: "value"
        textRole: "label"
    }



//    CLabel {
//        text: qsTr("Value")
//    }
//    SpinBox {
//        //leftIcon.name: "cil-diamond"
//        objectName: "value"
//        Layout.fillWidth: true
//        editable: true
//        to: typeCB.currentValue===1? 100 : 999999999
//        from: 0
//    }

    CLabel {
        text: qsTr("Code")
    }

    CIconTextField {
        leftIcon.name: "cil-user"
        objectName: "code"
        Layout.fillWidth: true
        readOnly: true
        enabled: false
    }
}
