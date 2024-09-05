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
import CoreUI
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


                NewDashboardWidget{
                    title: qsTr("Sales & Returns")
                    palette.window : CoreUI.color(CoreUI.Primary)
                    icon: "qrc:/icons/CoreUI/free/cil-dollar.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Today"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_day"]) : ""},
                            {label: qsTr("Today (POS)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_day_pos"]) : ""},

                            {label: qsTr("Month"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_month"]) : ""},
                            {label: qsTr("Month (POS)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_month_pos"]) : ""},

                            {label: qsTr("Returns (Today)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_returns_month"]) : ""},
                            {label: qsTr("Returns (Month)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["sales_day"]) : ""},
                            {label: qsTr("Profits (Today)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["daily_sales_profits"]) : ""},
                            {label: qsTr("Profits (Month)"), value: page.dashboard? Utils.formatCurrency(page.dashboard["monthly_sales_profits"]) : ""}
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Orders Status")
                    palette.window : CoreUI.color(CoreUI.Warning)
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
                    palette.window : CoreUI.color(CoreUI.Danger)
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Orders (Today)"), value: page.dashboard? page.dashboard["orders_day"] : ""},
                            {label: qsTr("Orders (POS Today)"), value: page.dashboard? page.dashboard["orders_day_pos"] : ""},

                            {label: qsTr("Orders (Month)"), value: page.dashboard? page.dashboard["orders_month"] : ""},
                            {label: qsTr("Orders (POS Month)"), value: page.dashboard? page.dashboard["orders_month_pos"] : ""},

                            {label: qsTr("Returns (Today)"), value: page.dashboard? page.dashboard["returns_day"] : ""},
                            {label: qsTr("Returns (Month)"), value: page.dashboard? page.dashboard["returns_month"] : ""},
                            {label: qsTr("Orders (Total)"), value: page.dashboard? page.dashboard["orders_total"] : ""},
                            {label: qsTr("Returns (Total)"), value: page.dashboard? page.dashboard["returns_total"] : ""},
                        ]
                    }
                }

                NewDashboardWidget{
                    title: qsTr("Statistics")
                    palette.window : CoreUI.color(CoreUI.Success)
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    DashboardWidgetTable{
                        modelRows: [
                            {label: qsTr("Sold  (Month)"), value: page.dashboard? page.dashboard["sold_stock_month"] : ""},
                            {label:qsTr("returned (Month)"), value: page.dashboard? page.dashboard["returned_stock_month"] : ""},
                            {label: qsTr("Net Sold (Month)"), value: page.dashboard? page.dashboard["net_sold_stock_month"] : ""},
                            {label: qsTr("Returns %"), value: page.dashboard? page.dashboard["stock_return_percentage"] : ""},
                            {label: qsTr("Available Stock"), value: page.dashboard? page.dashboard["stock_total"] : ""},
                            {label: qsTr("Sold (Total)"), value: page.dashboard? page.dashboard["sold_stock_total"] : ""}
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

