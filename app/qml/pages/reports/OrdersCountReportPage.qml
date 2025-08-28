import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI.Base

BasicViewPage {
    id: page
    title: qsTr("Orders count")
    delegate: AppDelegateChooser {}
    model: OrdersCountReportModel{}

    advancedFilter: [
                    {
                        "type": "combo",
                        "label": qsTr("product"),
                        "key": "products",
                        "options": {
                            "checkable": false,
                            "editable": true,
                            "defaultEntry": {
                                "name": qsTr("All Products"),
                                "id": null
                            },
                            "textRole": "name",
                            "valueRole": "id",
                            "dataUrl": "/products/list",
                            "filter": {
                                "onlyVariants": true
                            }
                        }
                    }, {
                        "type": "date",
                        "label": qsTr("from"),
                        "key": "from"
                    }, {
                        "type": "date",
                        "label": qsTr("to"),
                        "key": "to"
                    }, {
                        "type": "checkableCombo",
                        "label": qsTr("type"),
                        "key": "order_types",
                        "options": {
                            "checkable": true,
                            "editable": false,
                            "textRole": "name",
                            "valueRole": "value",
                            "values": [{"name": qsTr("POS"),"value":"pos"},{"name": qsTr("Online"),"value":"online"}]
                        }
                    }, {
                        "type": "combo",
                        "label": qsTr("Group By"),
                        "key": "group_by",
                        "options": {
                            "checkable": false,
                            "editable": false,
                            "textRole": "name",
                            "valueRole": "value",
                            "defaultEntry": {},
                            "values": [{"name": qsTr("Month"),"value":"month"},{"name": qsTr("Year"),"value":"year"},{"name": qsTr("Day"),"value":"day"}]
                        }
                    }]
}
