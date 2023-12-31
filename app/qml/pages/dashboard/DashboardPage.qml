import QtQuick;
import QtQuick.Controls
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import Qt5Compat.GraphicalEffects
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import Qt.labs.qmlmodels
import QtCharts
import PosFe
Page{
    id: page
    title: qsTr("Dashboard")
    background: Rectangle{color:"transparent";}
    property var dashboard;
    padding: window.mobileLayout? 0 : 15
    Flickable {
        id: flickable;
        anchors.fill: parent;
        implicitWidth: layout.implicitWidth
        contentHeight: layout.implicitHeight
        ColumnLayout{
            id: layout
            anchors.fill: parent
            DynamicGridLayout{
                clip: true
                id: gridLayout
                columnSpacing: 20
//                property int maxImplicitWidth: 0
//                Layout.minimumWidth: maxImplicitWidth
//                onWidthChanged: updateValues()
//                onImplicitWidthChanged: updateValues();

//                function updateValues()
//                {
//                    let maxLength=0;
//                    let count=0;
//                    for (var i=0; i<gridLayout.children.length; i++){
//                        let child=gridLayout.children[i];

//                        if(!child.width<=0){
//                            if(child.implicitWidth>maxLength){
//                                maxLength=child.implicitWidth;
//                            }

//                            count++;
//                        }
//                    }
//                    maxImplicitWidth=maxLength;
//                    let childCount=count;
//                    //part 2

//                    let decimalColumnCount=(gridLayout.width-(columnSpacing*childCount))/(maxImplicitWidth);

//                    for (let j=0; j<gridLayout.children.length; j++){
//                        let c=gridLayout.children[j];
//                        if(!c.width<=0){
//                            c.Layout.minimumWidth=maxImplicitWidth;
//                        }
//                    }

//                    let columnCount=parseInt(decimalColumnCount,10)

//                    if(columnCount<=0){
//                        columns=1
//                        return;
//                    }


//                    if(Number.isNaN(columnCount) || columnCount<=1){
//                        columns=columnCount;
//                        return;
//                    }

//                    if(columnCount>=childCount){
//                        columns=childCount;
//                        return;
//                    }

//                    if(childCount%2===0 && childCount%columnCount!==0){
//                        while(childCount%columnCount!==0){
//                            if(columnCount<=1){
//                                columns=columnCount;
//                                return;
//                            }
//                            columnCount--;
//                        }
//                    }

//                    columns=columnCount;

//                }

                NewDashboardWidget{
                    title: qsTr("Sales & Returns")
                    palette.window : "#2518AD"
                    icon: "qrc:/icons/CoreUI/free/cil-dollar.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Sales Today"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_day"]) : ""},
                            {label:qsTr("Sales This Month"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_month"]) : ""},
                            {label: qsTr("Sales Returns Today"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_returns_month"]) : ""},
                            {label: qsTr("Sales Returns This Month"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_day"]) : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Orders Status")
                    palette.window : "#5FA7EA"
                    //                    Layout.minimumWidth: gridLayout.maxWidth
                    icon: "qrc:/icons/CoreUI/free/cil-graph.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Pending"), value: page.dashboard? page.dashboard["orders_pending"] : ""},
                            {label:qsTr("Processing"), value: page.dashboard? page.dashboard["orders_processing"] : ""},
                            {label: qsTr("Returned"), value: page.dashboard? page.dashboard["orders_returned"] : ""},
                            {label: qsTr("Partial Return"), value: page.dashboard? page.dashboard["orders_partial_return"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Orders Statistics")
                    palette.window : "#F7A20F"
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Orders Today"), value: page.dashboard? page.dashboard["orders_day"] : ""},
                            {label:qsTr("Orders this Month"), value: page.dashboard? page.dashboard["orders_month"] : ""},
                            {label: qsTr("Returns Today"), value: page.dashboard? page.dashboard["returns_day"] : ""},
                            {label: qsTr("Returns this Month"), value: page.dashboard? page.dashboard["returns_month"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Statistics")
                    palette.window : "#DE4343"
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Orders Total"), value: page.dashboard? page.dashboard["orders_total"] : ""},
                            {label:qsTr("Returns Total"), value: page.dashboard? page.dashboard["returns_total"] : ""},
                            {label: qsTr("Available Stock"), value: page.dashboard? page.dashboard["stock_total"] : ""},
                            {label: qsTr("Sold Stock"), value: page.dashboard? page.dashboard["sold_stock_total"] : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Profits")
                    palette.window : "#2eb85c"
                    icon: "qrc:/icons/CoreUI/free/cil-dollar.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Daily Sales Profits"), value: page.dashboard? Utils.formatCurrency(page.dashboard["daily_sales_profits"]) : ""},
                            {label:qsTr("Monthly Sales Profits"), value: page.dashboard? Utils.formatCurrency(page.dashboard["monthly_sales_profits"]) : ""},
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Stock Sale")
                    palette.window : "#4f5d73"
                    icon: "qrc:/icons/CoreUI/free/cil-bar-chart.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Sold Stock This Month"), value: page.dashboard? page.dashboard["sold_stock_month"] : ""},
                            {label:qsTr("returned Stock This Month"), value: page.dashboard? page.dashboard["returned_stock_month"] : ""},
                            {label: qsTr("Net Sold Stock This Month"), value: page.dashboard? page.dashboard["net_sold_stock_month"] : ""},
                            {label: qsTr("Stock Return Percentage"), value: page.dashboard? page.dashboard["stock_return_percentage"] : ""}

                        ]
                    }
                }

                Connections{
                    target: Api;
                    function onDashboardReply(reply){
                        dashboard=reply;
                        if(dashboard.sales_chart.data.length<2)
                            return
                        salesChartModel.setRecords(dashboard.sales_chart.data);
                        salesProfitsChartModel.setRecords(dashboard.sales_profits_chart.data);

                    }
                }
            }//gridLayout end

            ChartView{
                id: chartView
                antialiasing: true
                Layout.fillWidth: true
                //Layout.fillHeight: true
                implicitHeight: 600
                legend.font.bold: false
                //legend.font.family: "Roboto"
                legend.font.pixelSize: 20
                theme: ChartView.ChartThemeLight
                titleFont.pixelSize: 24

                dropShadowEnabled: true
                animationOptions: ChartView.AllAnimations

                    margins.left: window.mobileLayout? 0 : 5
                    margins.right: window.mobileLayout? 0 : 5
                    margins.top:0
                    margins.bottom:5


                DateTimeAxis{
                    id: dtAxis
                    format: "MMM, dd"
                    min:  Utils.firstDayOfMonth();
                    max:  Utils.lastDayOfMonth();
                    tickCount: Math.min(chartView.width/130,31)
                    labelsFont.family: "Roboto"
                    labelsColor: "#666666"
                    gridVisible: false
                }



                ValueAxis{
                    id: valueAxis
                    min: salesChartModel.minValue;
                    max: salesChartModel.maxValue*1.1;
                    labelFormat: "IQD%.2i"
                    tickCount: 4
                    labelsFont.family: "Roboto"
                    labelsColor: "#666666"
                }


                SplineSeries {
                    id: salesSeries
                    name: qsTr("Sales")
                    axisX: dtAxis
                    axisY: valueAxis
                    pointsVisible: true

                }


                SplineSeries {
                    id: salesProfitsSeries
                    name: qsTr("Sales Profits")

                    axisX: dtAxis
                    axisY: valueAxis
                    pointsVisible: true

                }

                VXYModelMapper{
                    series: salesSeries
                    model: SalesChartModel{id: salesChartModel;

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

