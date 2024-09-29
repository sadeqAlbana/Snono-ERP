import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage{

    title: qsTr("Vendors Bills Attributes")


    ColumnLayout{
        id: page
        anchors.fill: parent;
        AppToolBar{
            id: toolBar
            view: tableView

            onSearch:(searchString)=> {
                var filter=model.filter;
                filter['query']=searchString
                model.filter=filter;
                model.requestData();
            }

        }


        CTableView{
            id: tableView
            Layout.fillHeight: true
            Layout.fillWidth: true


            delegate: AppDelegateChooser{
            }



            model: VendorBillAttributeModel{
                id: model;



            } //model end



        }
    }
}

