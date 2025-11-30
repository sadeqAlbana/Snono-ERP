import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe
import CoreUI

AppPage {
    id: page
    title: qsTr("Pack order")
    required property int orderId;

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        OrderPackingListView {
            id: returnListView
            Layout.fillHeight: true
            Layout.fillWidth: true
            orderId: page.orderId
        }
    }
}
