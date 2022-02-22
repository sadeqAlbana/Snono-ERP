import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import QtGraphicalEffects 1.0
import app.models 1.0
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import Qt.labs.qmlmodels 1.0
import "qrc:/common"
import QtCharts 2.15
Page{
    title: qsTr("Dashboard")
    background: Rectangle{color:"transparent";}
    property var dashboard;
    //    Rectangle{
    //        anchors.fill: parent
    //        color: "blue"
    //        opacity: 0.5
    //    }

    ScrollView {
        id:mainLayout
        anchors.fill: parent;
        contentWidth: availableWidth
        //padding: 25
        ColumnLayout{
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

                rowSpacing: 20

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
                        return1
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
                    Layout.minimumWidth: gridLayout.maxWidth
                    ColumnLayout{
                        anchors.fill: parent;
                        DashboardRowItem{
                            label: qsTr("Sales Today (IQD)")
                            value: dashboard? dashboard["sales_day"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Sales This Month (IQD)")
                            value: dashboard? dashboard["sales_month"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Sales Returns Today (IQD)")
                            value: dashboard? dashboard["sales_returns_day"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Sales Returns This Month (IQD)")
                            value: dashboard? dashboard["sales_returns_month"] : ""
                        }
                    }
                }

                NewDashboardWidget{
                    title: "Orders Status"
                    palette.window : "#5FA7EA"
                    Layout.minimumWidth: gridLayout.maxWidth
                    icon: "qrc:/icons/CoreUI/free/cil-graph.svg"

                    ColumnLayout{
                        anchors.fill: parent;
                        DashboardRowItem{
                            label: qsTr("Pending")
                            value: dashboard ? dashboard["orders_pending"]  : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Processing")
                            value: dashboard? dashboard["orders_processing"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Returned")
                            value: dashboard? dashboard["orders_returned"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Partial Return")
                            value: dashboard? dashboard["orders_partial_return"] : ""
                        }
                    }

                }

                NewDashboardWidget{
                    title: "Orders Statistics"
                    palette.window : "#F7A20F"
                    Layout.minimumWidth: gridLayout.maxWidth
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"
                    ColumnLayout{
                        anchors.fill: parent;
                        DashboardRowItem{
                            label: qsTr("Orders Today")
                            value: dashboard ? dashboard["orders_day"]  : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Orders this Month")
                            value: dashboard? dashboard["orders_month"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Returns Today")
                            value: dashboard? dashboard["returns_day"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Returns this Month")
                            value: dashboard? dashboard["returns_month"] : ""
                        }
                    }
                }

                NewDashboardWidget{
                    title: "Statistics"
                    palette.window : "#DE4343"
                    icon: "qrc:/icons/CoreUI/free/cil-gauge.svg"

                    Layout.minimumWidth: gridLayout.maxWidth

                    ColumnLayout{
                        anchors.fill: parent;
                        DashboardRowItem{
                            label: qsTr("Orders Total")
                            value: dashboard ? dashboard["orders_total"]  : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Returns Total")
                            value: dashboard? dashboard["returns_total"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Available Stock")
                            value: dashboard? dashboard["stock_total"] : ""
                        }
                        DashboardRowItem{
                            label: qsTr("Sold Stock")
                            value: dashboard? dashboard["sold_stock_total"] : ""
                        }
                    }
                }



                Connections{
                    target: Api;
                    function onDashboardReply(reply){
                        dashboard=reply;
                        salesChartModel.setupData(dashboard.sales_chart);

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
                LineSeries {
                    id: splineSeries
                    name: "Sales"
                    axisX: DateTimeAxis{
                        format: "yyyy-MM-dd"
                        min: Utils.firstDayOfMonth()
                        max: Utils.lastDayOfMonth()
                        tickCount: 15
                    }
                    axisY: ValueAxis{
                        min: salesChartModel.minValue;
                        max: salesChartModel.maxValue*1.1;
                        labelFormat: "IQD%.2i"

                    }
                }

                VXYModelMapper{
                    id: chartMapper
                    series: splineSeries
                    model: SalesChartModel{id: salesChartModel}
                    firstRow: 0
                    xColumn: 0
                    yColumn: 1
                }
            }
        } //columnLayout End

        Component.onCompleted: {
            Api.requestDashboard();
        } //ScrollView End
    }



}

