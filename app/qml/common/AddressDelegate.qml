import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
ItemDelegate {
    id: control


    //     objectName: "name"
    //     objectName: "country"
    //     objectName: "province"
    //     objectName: "city"
    //     objectName: "district"
    //     objectName: "postcode"
    //     objectName: "building"
    //     objectName: "floor"
    //     objectName: "apartment"
    //     objectName: "phone"
    //     objectName: "details"
    //     objectName: "lo"
    //     objectName: "la"

    property string name;
    property string country;
    property string province;
    property string city;
    property string distrcit;
    property string postalCode;
    property string building;
    property string floor;
    property string apartment;
    property string phone;
    property string details;
    property string lo;
    property string la;



    contentItem: GridLayout{

    }
}
