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
Page{
    title: qsTr("Dashboard")
    background: Rectangle{color:"transparent";}

    ColumnLayout {
        id:mainLayout
        anchors.fill: parent;
        //width: parent.width
        //height: parent.height

        GridLayout{
            id: gridLayout
            //Layout.fillWidth: true
            Layout.margins: 25
            //Layout.fillHeight: true
            columnSpacing: 40

            rowSpacing: 40
            columns: {
                var childrenLength=0;
                var columnsCount=1;
                var maxLength=0;
                var childCount=0
                for (var i=0; i<gridLayout.children.length; i++){
                    var child=gridLayout.children[i];
                    if(child.width!=0 && child.implicitWidth>maxLength){
                        childCount++;
                        maxLength=child.implicitWidth;

                    }
                }
                var columnCount=gridLayout.width/(maxLength);
                return columnCount
            }

            AppDashboardWidget{
                id: activitiesThisMonthWidget
                //color: "#2618B0"
                color: "#2E8DE4"

                //color: "#F7A20F"
                text: qsTr("Sales")
                //image: FluidControls.Utils.iconUrl("action/timeline")
                //value: "150"
            }

            AppDashboardWidget{
                id: activitiesTodayWidget
                //color: "#2618B0"
                color: "#2eb85c"

                //color: "#F7A20F"
                text: qsTr("Orders")
                //image: FluidControls.Utils.iconUrl("action/timeline")

                //value: "150"
            }



            AppDashboardWidget{
                id: balanceWidget
                color: "#F7A20F"
                text: qsTr("Vendor Bills")
                //value: Utils.formatNumber("1243000")
                //image: FluidControls.Utils.iconUrl("editor/attach_money")

            }
            AppDashboardWidget{
                id: commissionsWidget
                color: "#DD4141"
                text: qsTr("Orders Today")
                //value: Utils.formatNumber("54000")
                //image: FluidControls.Utils.iconUrl("editor/attach_money")

            }
//            Connections{
//                target: Core;
//                function onDashboardReply(dashboard){
//                    activitiesThisMonthWidget.value=Utils.formatNumber(dashboard.activities_month)
//                    activitiesTodayWidget.value=Utils.formatNumber(dashboard.activities_today)
//                    balanceWidget.value=dashboard.balance_cash
//                    commissionsWidget.value=dashboard.balance_comm
//                }
//            }
        }
    }

//    Component.onCompleted: {
//        Core.requestDashboard();
//    }



}

