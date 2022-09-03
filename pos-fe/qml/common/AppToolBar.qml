import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import Qt.labs.qmlmodels 1.0
import QtQuick.Layouts
import "qrc:/CoreUI/palettes"

ToolBar {
    id: control
    signal search(var searchString);
    signal filterClicked(var filter);
    property var advancedFilter : null;
    required property var tableView
    property bool searchVisible: true
    Layout.fillWidth: true
    palette.button: "transparent"
    RowLayout{
        spacing: 15
        anchors.fill: parent;
        CMenuBar{
            spacing: 20
            Layout.preferredHeight: 45
            CActionsMenu{
                title: qsTr("Actions");
                icon:"cil-settings"
                actions: tableView.actions
            }//Menu

            CMenu{
                title: qsTr("columns");
                icon:"cil-list"
                Repeater{
                    model: tableView.columns
                    CMenuItem{
                        checkable: true
                        text: tableView.model.headerData(modelData,Qt.Horizontal)
                        palette.windowText: enabled? hovered? "#fff" : "#000" : "silver"
                        checked: true
                        onCheckedChanged: {
                            if(checked)
                                tableView.showColumn(modelData);
                            else{
                                tableView.hideColumn(modelData)
                            }
                        }
                    }
                }
            }//Menu



            CMenu{
                Repeater{
                    id: repeater
                    model: [
                        {"type": "text","label": "Customer Name","key": "customer_name","options":{"placeholderText":"All..."}},
                        {"type": "text","label": "Customer Phone","key": "customer_phone","options":{"placeholderText":"All..."}},
                        {"type": "text","label": "Customer Address","key": "customer_address","options":{"placeholderText":"All..."}},

                        {"type": "combo","label": "product","key": "product_id",
                            "options":{"editable":true,"defaultEntry":{"name":"All Products","id":null},"textRole": "name", "valueRole": "id","dataUrl": "/products/list",
                                "filter":{"onlyVariants":true}}},

                        {"type": "date","label": "from","key": "from"},
                        {"type": "date","label": "to","key": "to"}]

                    delegate: DelegateChooser{
                        role: "type"
                        DelegateChoice {roleValue: "text"; CTextField {}}
                        DelegateChoice {roleValue: "combo"; CFilterComboBox {
                                dataUrl: modelData.options["dataUrl"]
                                editText: modelData.options["editable"];
                                valueRole: modelData.options["valueRole"]
                                textRole: modelData.options["textRole"]
                                defaultEntry: modelData.options["defaultEntry"]
                                filter: modelData.options["filter"]
                                Component.onCompleted: console.log("ttt: "+ JSON.stringify(model))
                            }
                        }

                        DelegateChoice {roleValue: "date"; CDateInput {}}
                    }
                }
            }

            //now delegate choice for filter
        }//MenuBar

        CButton{
            id: filter
            visible: advancedFilter
            Layout.preferredHeight: 45
            icon.name: "cil-filter"
            text: qsTr("Filter")
            palette: BrandInfo{}
            checkable: false
            onClicked: pp.open();

            TableFilter{
                id: pp
                parent: filter
                form: advancedFilter;

                onClicked: (filter)=>{
                               filterClicked(filter);
                           }
            }



        }

        HorizontalSpacer{}

        CTextField{
            id: _search
            visible: searchVisible
            Layout.preferredHeight: 50
            Layout.preferredWidth: 300
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
            font.pixelSize: 18
            placeholderText: qsTr("Search...")
            rightIcon: "cil-search"
            onEntered: control.search(_search.text)
        }//search
    }// layout end
}
