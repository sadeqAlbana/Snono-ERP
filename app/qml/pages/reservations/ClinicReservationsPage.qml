import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Qt.labs.qmlmodels
import QtQuick.Dialogs
import QtCore
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import CoreUI.Impl
import PosFe
import CoreUI
import CoreUI.Palettes
import "qrc:/PosFe/qml/screens/utils.js" as Utils

AppPage {
    id: page
    title: qsTr("Clinic Reservations")
    function clearDate(){
        page.date=new Date()
    }

    function setDate(newDate){
        page.date=newDate
        dateChanged();
    }

    property date date: new Date()
    onDateChanged: {
        // control.text=Qt.formatDate(page.date,"yyyy-MM-dd")
    }

    GridLayout {
        id: layout
        rows: 5
        anchors.fill: parent;


        RowLayout{
            Layout.row: 0

            Button{
                text: "‹"
                flat: true
                padding: 4
                bottomPadding: 7
                Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                display: AbstractButton.TextOnly
                font.pixelSize: 35
                implicitWidth: 50
                onClicked: setDate(page.date.addMonths(-1));


            }

            Label{
                Layout.fillWidth: true
                text: Qt.formatDate(page.date,"MMMM yyyy")
                font.pixelSize: 16
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignCenter
            }

            Button{
                text: "›"
                flat: true
                font.pixelSize: 35
                padding: 4
                bottomPadding: 7
                Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
                display: AbstractButton.TextOnly
                implicitWidth: 50
                onClicked: setDate(page.date.addMonths(1));



            }
        }



        DayOfWeekRow {
            locale: grid.locale
            Layout.row: 1
            Layout.fillWidth: true
            hoverEnabled: true
        }

        CMonthGrid {
            id: grid
            date: page.date
            month: page.date.getMonth();
            year: page.date.getFullYear();
            locale: Qt.locale("en_US")
            Layout.row: 2
            Layout.fillWidth: true
            Layout.fillHeight: true



            onClicked: (date)=> {
                page.date=date;
            }
        }

        Rectangle{
            color: "black"
            implicitHeight: 1
            Layout.fillWidth: true
            Layout.row: 3
            Layout.topMargin: 5
            Layout.bottomMargin: 5

        }

        RowLayout{
            Layout.row: 4
            CButton{
                text: qsTr("Today")
                palette: BrandLight{}
                layer.enabled: false
                onClicked: {
                    page.date= new Date();
                }

            }
            Item{Layout.fillWidth: true;}
            CButton{
                text: qsTr("Clear")
                palette: BrandLight{}
                layer.enabled: false
                onClicked: page.clearDate();
            }
        }

    }
}
