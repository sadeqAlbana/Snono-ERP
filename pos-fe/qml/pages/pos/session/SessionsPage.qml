import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/CoreUI/components/base"
import "qrc:/CoreUI/components/forms"
import "qrc:/CoreUI/components/tables"
import "qrc:/CoreUI/components/notifications"
import "qrc:/CoreUI/components/buttons"
import "qrc:/CoreUI/components/views"
import "qrc:/CoreUI/components/SharedComponents"
import "qrc:/screens/Utils.js" as Utils
import QtGraphicalEffects 1.0
import app.models 1.0
import Qt.labs.qmlmodels 1.0
import "qrc:/common"

Page{
    //anchors.margins: 20
     title: "Pos Sessions"
    palette.window: "transparent"

    //ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
    //    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
    GridLayout{
        columns: 4
        anchors.fill: parent;
       anchors.margins: 50
        width: parent.width


        PosSessionsModel{
            id: sessionsModel
            Component.onCompleted: currentSession();

            onNewSessionResponse: {
                initSession(reply.pos_session);

            }

            onCurrentSessionResponse: {
                //console.log(JSON.stringify(reply))
                if(reply.status===200){ //there is an open session
                    var session=reply.pos_session;
                    sessionCard.totalAmount=reply.pos_session.total;
                    sessionCard.ordersCount=reply.pos_orders?  reply.pos_orders.length : 0
                    sessionCard.session=session;
                    sessionCard.visible=true


                }else{ //no session opened
                    newSessionButton.visible=true
                    sessionCard.visible=false;
                    //sessionsModel.newSession();
                }
            }

            onCloseSessionResponse: {
                if(reply.status===200){
                    toastrService.push("Success",reply.message,"success",2000)
                    sessionsModel.requestData();
                }else{
                    toastrService.push("Error",reply.message,"error",2000)

                }
            }
            function initSession(session){
                baseLoader.push("qrc:/pages/cashier/CashierPage.qml",{"sessionId": session.id})

            }
        }



        CButton{
            id: newSessionButton
            radius: width> height ? width : height
            color: "#39f";
            icon.color: "white"
            icon.name: "cil-plus"
            icon.height: height*0.8
            icon.width: width*0.8
            implicitHeight: 200
            implicitWidth: 200
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onClicked: sessionsModel.newSession();
            visible: false

        }
        SessionCard{
            id: sessionCard
            visible: false
            Layout.fillWidth: true
            //ordersCount: sessionsModel.data(model.row,"pos_orders") ? sessionsModel.data(model.row,"pos_orders").length : 0
            //totalAmount: model.total? Utils.formatNumber(model.total) : Utils.formatNumber(0.0)
            onClose: {
                sessionsModel.closeSession(session.id)
                sessionCard.visible=false
                newSessionButton.visible=true
            }

            onResume: {
                sessionsModel.initSession(session.id)
            }
        }

    }
}
