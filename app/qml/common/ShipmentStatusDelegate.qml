import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
CTableViewDelegate {
    padding: 12
    leftPadding: (width/3)
    rightPadding: leftPadding
    implicitWidth: 350
    contentItem: Badge {
        text: switch (model.display) {
            case "manifest_created":        return qsTr("Manifest Created");
            case "in_transit":              return qsTr("In Transit");
            case "at_local_delivery_center":return qsTr("At Local Delivery Center");
            case "out_for_delivery":        return qsTr("Out for Delivery");
            case "delivered":               return qsTr("Delivered");
            case "returned":                return qsTr("Returned");
            case "partially_returned":      return qsTr("Partially Returned");
            case "cancelled":               return qsTr("Cancelled");
            default: return "N.A";
        }

        state: switch (model.display) {
            case "manifest_created":        return "info";
            case "in_transit":              return "secondary";
            case "at_local_delivery_center":return "warning";
            case "out_for_delivery":        return "primary";
            case "delivered":               return "success";
            case "returned":                return "danger";
            case "partially_returned":      return "orange";
            case "cancelled":               return "danger";
            default: return "Invalid";
        }
    }

}
