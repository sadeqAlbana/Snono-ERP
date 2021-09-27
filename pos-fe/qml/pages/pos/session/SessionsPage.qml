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

ScrollView{
    //anchors.margins: 20
    contentWidth: baseLoader.width

    //ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
//    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
    GridLayout{
        columns: 4
        anchors.fill: parent;
        //anchors.margins: 50
        width: parent.width

        property string title: "Pos sessions"

        PosSessionsModel{
            id: sessionsModel
            Component.onCompleted: repeater.model=sessionsModel

            onNewSessionResponse: {
                var sessionId=reply.pos_session.id;
            }
        }


        CButton{
            radius: width> height ? width : height
            color: "#39f";
            icon.color: "white"
            icon.source: "qrc:/assets/icons/coreui/free/cil-plus.svg"
            icon.height: height*0.8
            icon.width: width*0.8
            implicitHeight: 200
            implicitWidth: 200
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

            onClicked: sessionsModel.newSession();

        }

        Repeater{
            id:repeater
            SessionCard{
            Layout.fillWidth: true
            ordersCount: sessionsModel.data(model.row,"pos_orders").length
            totalAmount: sessionsModel.total? Utils.formatNumber(sessionsModel.total) : Utils.formatNumber(0.0)
            }
        }
    }
}
