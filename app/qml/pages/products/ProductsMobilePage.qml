import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage{
    title: qsTr("Products")
    padding: 10
    ColumnLayout{
        id: page
        anchors.fill: parent;
        spacing: 10




        CIconTextField{
            id: search
            Layout.preferredHeight: 50
            Layout.preferredWidth: 300
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignCenter
            font.pixelSize: 18
            placeholderText: qsTr("Search...")
            rightIcon.name: "cil-search"

            onEntered: () => {
                var filter=model.filter;
                filter['query']=search.text
                model.filter=filter;
                model.requestData();
            }
        }//search



        CTreeView{
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: ProductsProxyModel{
                sourceModel: ProductsModel{
                    id:model
                }

            }
        }




    }//layout

}

