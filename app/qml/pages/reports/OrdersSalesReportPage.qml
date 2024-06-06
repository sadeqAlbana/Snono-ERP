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
    title: qsTr("Orders Report")
    method: "POST"
    url: "/reports/ordersSales"

    applyHandler: function(url, method, data){
        NetworkManager.post(url, data).subscribe(function (res) {
             model.print(res.json("data"),from.text,to.text);
        });
    }


    OrdersSalesReportModel{
        id: model;
    }

    columns: 2
    CLabel {
        text: qsTr("from")
    }

    CDateInput{
        id: from
        objectName: "from"
    }

    CLabel {
        text: qsTr("to")
    }

    CDateInput{
        id: to
        objectName: "to"
    }

    Label{
        text: qsTr("Status")
    }

    CCheckableFilterComboBox {
        objectName: "status"
        width: control.contentItem.width
        checkable: true
        editable: true
        textRole: "name"
        valueRole: "value"
        dataUrl: "/orders/status/list"
    }
}
