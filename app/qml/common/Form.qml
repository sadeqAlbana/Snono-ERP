import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Qt.labs.qmlmodels
import CoreUI.Forms
Container {
    id: container
    property int layout: Qt.Vertical
    contentItem: GridView {
        model: container.contentModel
//        snapMode: ListView.SnapOneItem
//        section.property: "key"
//        section.criteria: ViewSection.FullString
//        section.delegate: Label{
//            width: 50
//            height: 52
//            horizontalAlignment: Text.AlignLeft
//            leftPadding: 13
//            text: "test"
//            font.bold: true
//            font.pixelSize: 10
//            background: Rectangle{color: "green"}
//            Component.onCompleted: console.log("created")
//        }
    }


    Repeater{
        model: ListModel {
            id: listModel
            ListElement { type: "text"; key:"name"  }
            ListElement { type: "spin";  key: "age"}
            ListElement { type: "combobox";  key: "Day"}
        }

        delegate: DelegateChooser{
            role: "type"
            DelegateChoice{roleValue: "text"; CTextField{width: 200; height: 50; }}
            DelegateChoice{roleValue: "spin"; SpinBox{width: 200; height: 50}}
            DelegateChoice{roleValue: "combobox"; CComboBox{width: 200; height: 50}}

        }


    }

}
