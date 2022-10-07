import QtQuick;
import QtQuick.Controls.Basic;
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Qt.labs.qmlmodels

import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import "qrc:/PosFe/qml/screens/utils.js" as Utils
import PosFe

AppPage{
    title: qsTr("Pos Sessions")
    palette.window: "transparent"
    GridLayout{
        columns: 4
        anchors.fill: parent;
        width: parent.width


        PosSessionsModel{
            id: sessionsModel
            Component.onCompleted: currentSession();

            onNewSessionResponse:(reply)=> {
                initSession(reply.pos_session.id);

            }

            onCurrentSessionResponse:(reply) => {
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

            onCloseSessionResponse:(reply)=> {
                if(reply.status===200){
                    sessionsModel.requestData();
                }
            }
            function initSession(sessionId){
                stack.push("qrc:/PosFe/qml/pages/cashier/CashierPage.qml",{"sessionId": sessionId})
            }
        }

        CButton{
            id: newSessionButton
            radius: width> height ? width : height
            palette.button: "#39f";
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
            onClose:()=> {
                sessionsModel.closeSession(session.id)
                sessionCard.visible=false
                newSessionButton.visible=true
            }
            onResume:()=> {
                sessionsModel.initSession(session.id)
            }
        }
    }
}
