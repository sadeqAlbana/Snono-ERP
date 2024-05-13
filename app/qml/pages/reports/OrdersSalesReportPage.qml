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
        console.log("applied");
        NetworkManager.post(url, data).subscribe(function (res) {
            // console.log(JSON.stringify(res.json()))
             model.print(res.json("data"));
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
        objectName: "from"
    }

    CLabel {
        text: qsTr("to")
    }

    CDateInput{
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
