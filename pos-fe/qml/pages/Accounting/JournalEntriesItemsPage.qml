import QtQuick;import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels 1.0
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import "qrc:/common"
import App.Models 1.0


AppPage{

    title: qsTr("Journal Entries Items")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            tableView: tableView
        }



        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true
            actions: [
                Action{ text: qsTr("Deposit Money"); icon.name: "cil-dollar"; onTriggered: dialog.open();}]

            delegate: DelegateChooser{
                role: "delegateType"
                DelegateChoice{ roleValue: "text"; CTableViewDelegate{}}
                DelegateChoice{ roleValue: "currency"; CurrencyDelegate{}}
                DelegateChoice{ roleValue: "internal_type"; InternalTypeDelegate{}}
                DelegateChoice{ roleValue: "type"; TypeDeleagate{}}
            }

            model: JournalEntriesItemsModel{
                id: model;



            } //model end

        }
    }
}

