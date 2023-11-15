import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import PosFe
AppPage{

    title: qsTr("Product Attributes")
    StackView.onActivated: model.refresh();

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

            actions: [
                CAction{ text: qsTr("Add"); icon.name: "cil-plus"; onTriggered: Router.navigate("qrc:/PosFe/qml/pages/products/ProductAttributeForm.qml",
                                                                                                {
                                                                                                                        "title": qsTr("Add Attribute")
                                                                                                                    })},

                CAction {
                    text: qsTr("Edit")
                    icon.name: "cil-pen"
                    onTriggered: Router.navigate("qrc:/PosFe/qml/pages/products/ProductAttributeForm.qml",
                                                 {
                                                     "title": qsTr("Edit"),

                                                 "keyValue": model.jsonObject(tableView.currentRow).id
                                                 })
                    enabled:tableView.currentRow>=0; permission: "prm_edit_products_attributes";

                },
                CAction{ text: qsTr("Delete");
                    icon.name: "cil-delete";
                    onTriggered: Api.removeAttribute(model.data(tableView.currentRow,"id"))
                    .subscribe(function(response){
                                            if(response.json("status")===200){
                                                model.refresh();
                                            }
                                        })}
            ]

            model: ProductsAttributesAttributesModel{
                id: model
            }
        }
    }
}

