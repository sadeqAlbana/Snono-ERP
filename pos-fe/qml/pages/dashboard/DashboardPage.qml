import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import QtQuick.Controls
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import Qt5Compat.GraphicalEffects
import App.Models 1.0
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"
import QtCharts 2.15
Page{
    title: qsTr("Dashboard")
    background: Rectangle{color:"transparent";}
    property var dashboard;

//    Flickable{
//        anchors.fill: parent;
//        implicitWidth: rect.implicitWidth
//        Rectangle{
//            id: rect
//            anchors.fill: parent
//            implicitHeight: 500
//            implicitWidth: 500
//        }
//    }
    Flickable {
        anchors.fill: parent;
        implicitWidth: layout.implicitWidth
        contentHeight: layout.implicitHeight
        //contentWidth: availableWidth
        //implicitHeight: layout.implicitHeight
        //padding: 25
        ColumnLayout{
            id: layout
            anchors.fill: parent
            GridLayout{
                clip: true
                id: gridLayout
                columnSpacing: 20
                Layout.leftMargin: 10
                Layout.rightMargin: 10
                property int maxWidth: 0
                onWidthChanged: {
                    var childrenLength=gridLayout.children.length;
                    var maxLength=0;
                    for (var i=0; i<childrenLength; i++){
                        var child=gridLayout.children[i];
                        if(child.implicitContentWidth>maxLength){
                            maxLength=child.implicitWidth;
                        }
                    }
                    maxWidth=maxLength
                }

//                rowSpacing: 20

                columns: {
                    var childrenLength=0;
                    var columnsCount=1;
                    var maxLength=0;
                    var childCount=0
                    for (var i=0; i<gridLayout.children.length; i++){
                        var child=gridLayout.children[i];

                        if(child.width!==0 && child.implicitContentWidth>maxLength){
                            childCount++;
                            maxLength=child.implicitContentWidth;

                        }
                    }
                    var columnCount=parseInt(gridLayout.width/(maxLength),10);
                    if(Number.isNaN(columnCount))
                        return 1
                    if(columnCount===1)
                        return 1

                    while(gridLayout.children.length%columnCount!==0){
                        if(columnCount<=1)
                            return 1
                        columnCount--;
                    }
                    return columnCount
                }

                NewDashboardWidget{
                    title: "Sales & Returns"
                    palette.window : "#2518AD"
                    icon: "qrc:/icons/CoreUI/free/cil-dollar.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Sales Today"), value: dashboard? dashboard["sales_day"] : ""},
                            {label:qsTr("Sales This Month"), value: dashboard? dashboard["sales_month"] : ""},
                            {label: qsTr("Sales Returns Today"), value: dashboard? dashboard["sales_returns_month"] : ""},
                            {label: qsTr("Sales Returns This Month"), value: dashboard? dashboard["sales_day"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: "Orders Status"
                    palette.window : "#5FA7EA"
                    //                    Layout.minimumWidth: gridLayout.maxWidth
                    icon: "qrc:/icons/CoreUI/free/cil-graph.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Pending"), value: dashboard? dashboard["orders_pending"] : ""},
                            {label:qsTr("Processing"), value: dashboard? dashboard["orders_processing"] : ""},
                            {label: qsTr("Returned"), value: dashboard? dashboard["orders_returned"] : ""},
                            {label: qsTr("Partial Return"), value: dashboard? dashboard["orders_partial_return"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: "Orders Statistics"
                    palette.window : "#F7A20F"
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Orders Today"), value: dashboard? dashboard["orders_day"] : ""},
                            {label:qsTr("Orders this Month"), value: dashboard? dashboard["orders_month"] : ""},
                            {label: qsTr("Returns Today"), value: dashboard? dashboard["returns_day"] : ""},
                            {label: qsTr("Returns this Month"), value: dashboard? dashboard["returns_month"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: "Statistics"
                    palette.window : "#DE4343"
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Orders Total"), value: dashboard? dashboard["orders_total"] : ""},
                            {label:qsTr("Returns Total"), value: dashboard? dashboard["returns_total"] : ""},
                            {label: qsTr("Available Stock"), value: dashboard? dashboard["stock_total"] : ""},
                            {label: qsTr("Sold Stock"), value: dashboard? dashboard["sold_stock_total"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: "Profits"
                    palette.window : "#2518AD"
                    icon: "qrc:/icons/CoreUI/free/cil-dollar.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Daily Sales Profits"), value: dashboard? dashboard["daily_sales_profits"] : ""},
                            {label:qsTr("Monthly Sales Profits"), value: dashboard? dashboard["monthly_sales_profits"] : ""}
                        ]
                    }
                }


                Connections{
                    target: Api;
                    function onDashboardReply(reply){
                        dashboard=reply;
                        salesChartModel.setupData(dashboard.sales_chart.data);
                        salesProfitsChartModel.setupData(dashboard.sales_profits_chart.data);

                    }
                }
            }//gridLayout end

            ChartView{
                antialiasing: true
                Layout.fillWidth: true
                //Layout.fillHeight: true
                implicitHeight: 600
                smooth: true
                legend.font.bold: true
                theme: ChartView.ChartThemeLight
                animationOptions: ChartView.AllAnimations

                DateTimeAxis{
                    id: dtAxis
                    format: "yyyy-MM-dd hh:mm"
                    min: Utils.firstDayOfMonth()
                    max: Utils.lastDayOfMonth()
                    tickCount: 15
                }
                ValueAxis{
                    id: valueAxis
                    min: salesChartModel.minValue;
                    max: salesChartModel.maxValue*1.1;
                    labelFormat: "IQD%.2i"
                    tickCount: 10
                }

                LineSeries {
                    id: salesSeries
                    name: "Sales"
                    axisX: dtAxis
                    axisY: valueAxis

                }


                LineSeries {
                    id: salesProfitsSeries
                    name: "Sales Profits"
                    axisX: dtAxis
                    axisY: valueAxis
                }

                VXYModelMapper{
                    series: salesSeries
                    model: SalesChartModel{id: salesChartModel}
                    firstRow: 0
                    xColumn: 0
                    yColumn: 1
                }


                VXYModelMapper{
                    series: salesProfitsSeries
                    model: SalesChartModel{id: salesProfitsChartModel}
                    firstRow: 0
                    xColumn: 0
                    yColumn: 1
                }


            }
        } //columnLayout End

        Component.onCompleted: {
            Api.requestDashboard();
        } //ScrollView End
    }//flickable
}

