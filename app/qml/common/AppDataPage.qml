import QtQuick

AppPage {
    id: page

    required property url link;
    property var keyValue //key value
    property string dataKey: "id"; //query param key or json object key, default is id
    property string method: "GET";
    property var dataRecord;
    Component.onCompleted: {

        if(page.method==="GET"){
            NetworkManager.get(link+'?'+dataKey+'='+keyValue).subscribe(function(response){
            page.dataRecord=response.json('data');
        });

        }
        else if(page.method=="POST"){
            NetworkManager.post(link,{dataKey: keyValue}).subscribe(function(response){
            page.dataRecord=response.json('data');
        });

        }
    }
}
