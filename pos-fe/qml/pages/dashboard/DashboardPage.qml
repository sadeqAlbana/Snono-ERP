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
    padding: 15
    Flickable {
        id: flickable;
        anchors.fill: parent;

        implicitWidth: layout.implicitWidth
        contentHeight: layout.implicitHeight
        //padding: 25
        ColumnLayout{
            id: layout
            anchors.fill: parent
            GridLayout{
                clip: true
                id: gridLayout
                columnSpacing: 20
                property int maxImplicitWidth: 0
                Layout.minimumWidth: maxImplicitWidth
                onWidthChanged: updateValues()
                onImplicitWidthChanged: updateValues();

                function updateValues()
                {
                    let maxLength=0;
                    let count=0;
                    for (var i=0; i<gridLayout.children.length; i++){
                        let child=gridLayout.children[i];

                        if(!child.width<=0){
                            if(child.implicitWidth>maxLength){
                                maxLength=child.implicitWidth;
                            }

                            count++;
                        }
                    }
                    maxImplicitWidth=maxLength;
                    let childCount=count;
                    //part 2

                    let decimalColumnCount=(gridLayout.width-(columnSpacing*childCount))/(maxImplicitWidth);

                    for (let j=0; j<gridLayout.children.length; j++){
                        let c=gridLayout.children[j];
                        if(!c.width<=0){
                            c.Layout.minimumWidth=maxImplicitWidth;
                        }
                    }

                    let columnCount=parseInt(decimalColumnCount,10)

                    if(columnCount<=0){
                        columns=1
                        return;
                    }


                    if(Number.isNaN(columnCount) || columnCount<=1){
                        columns=columnCount;
                        return;
                    }

                    if(columnCount>=childCount){
                        columns=childCount;
                        return;
                    }




                    if(childCount%2===0 && childCount%columnCount!==0){
                        while(childCount%columnCount!==0){
                            if(columnCount<=1){
                                columns=columnCount;
                                return;
                            }
                            columnCount--;
                        }
                    }

                    columns=columnCount;

                }

//                Timer{
//                    running: true
//                    interval: 5000
//                    repeat: true

//                    onTriggered: {
//                        console.log("flicked")
//                        gridLayout.lay

//                    }
//                }



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
                legend.font.bold: true
                theme: ChartView.ChartThemeLight
                animationOptions: ChartView.AllAnimations

                    margins.left: 5
                    margins.right:5
                    margins.top:0
                    margins.bottom:5


                DateTimeAxis{
                    id: dtAxis
                    format: "dd"
                    min:  salesChartModel.maxDateUTC? new Date(1659301200000) : new Date()
                    max:  salesChartModel.maxDateUTC? new Date(1661893200000) : new Date()
                    tickCount: 4
                    labelsFont.family: "Roboto"
                    labelsFont.bold: true
                    labelsColor: "#666666"

//                    gridVisible: false
                }

                ValueAxis{
                    id: valueAxis
                    min: salesChartModel.minValue;
                    max: salesChartModel.maxValue*1.1;
                    labelFormat: "IQD%.2i"
                    tickCount: 5
                    labelsFont.bold: true
                    labelsFont.family: "Roboto"
                    labelsColor: "#666666"
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
                    model: SalesChartModel{id: salesChartModel;
                    onMinDateUTCChanged: console.log("min: " + minDateUTC);
                    onMaxDateUTCChanged: console.log("max: " + maxDateUTC);

                    }
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

