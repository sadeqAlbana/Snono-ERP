import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import PosFe
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppDialog {
    id: dialog
    title: qsTr("Pay Bill");
    property var initialValues;
    CFormView{
        initialValues: dialog.initialValues
        showReset: false
        header.visible: true
        title: dialog.title;
        rowSpacing: 10
        url: "/vendorBill/pay"
        method: "POST"

        CLabel{
            text: qsTr("Pay with");
        }

        CFilterComboBox{
            Layout.preferredWidth: 400
            objectName: "account_id";
            Layout.fillWidth: true
            dataUrl: "/accounts"
            filter:{"type":"liquidity"}
            textRole: "name";
            valueRole: "id"

        }

        CLabel{
            text: qsTr("Amount");
        }

        CTextField{
            objectName: "total"
            Layout.fillWidth: true;
            // text: Utils.formatCurrency(amount)
            readOnly: true
        }
    }
}
