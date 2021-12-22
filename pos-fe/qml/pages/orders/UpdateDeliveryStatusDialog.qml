import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/screens/Utils.js" as Utils
import app.models 1.0

Popup {
    id: dialog
    modal: true
    anchors.centerIn: parent;
    parent: Overlay.overlay

    signal accepted(var status);


    onAccepted: close();


    width: 450
    height: parent.height*0.3
    background: Rectangle{color: "transparent"}
    Overlay.modal: Rectangle {
        color: "#C0000000"
    }

    enter: Transition {
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0 }
    }


    exit: Transition {
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0 }
    }

    Card{
        title: qsTr("Update Delivery Status")
        anchors.fill: parent;
        ColumnLayout{
            anchors.fill: parent;
            anchors.margins: 10

            CComboBoxGroup{
                id: cb
                label.text: qsTr("Status");
                comboBox.valueRole: "value"
                comboBox.textRole: "modelData"
                comboBox.model: ListModel {
                    ListElement { modelData: qsTr("Pending");   value: "pending";}
                    ListElement { modelData: qsTr("Processing"); value: "processing";}
                    ListElement { modelData: qsTr("Delivered");    value: "delivered";}
                }
        }

        }

        footer: RowLayout{

            Rectangle{
                color: "transparent"
                Layout.fillWidth: true

            }

            CButton{
                text: qsTr("Cancel")
                color: "#e55353"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.close();


            }
            CButton{
                text: qsTr("Update")
                color: "#2eb85c"
                textColor: "#ffffff"
                implicitHeight: 50
                Layout.margins: 10
                onClicked: dialog.accepted(cb.comboBox.currentValue);
            }
        } //footer end

    } //card end


}
