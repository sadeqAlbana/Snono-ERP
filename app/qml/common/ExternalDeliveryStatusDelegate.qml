import QtQuick;
import QtQuick.Controls.Basic;
import CoreUI.Base
import CoreUI.Forms
import CoreUI.Views
import CoreUI.Notifications
import CoreUI.Buttons
import "qrc:/PosFe/qml/screens/utils.js" as Utils
CTableViewDelegate {
    padding: 12
    leftPadding: (width/6)
    rightPadding: leftPadding
    property var order;
    implicitWidth: 150



//    implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
//                            implicitContentWidth + leftPadding + rightPadding)
    contentItem: Badge{

        text: model.display?? " "
        state: switch(model.display){
               case "تم تسجيل الطلب": return "info";
               case "بالطريق مع المندوب": return "primary";
               case "تم تسليم الطلب": return "success";
               case "راجع": return "danger";
               case "راجع جزئي": return "warning";
               case "راجع جزئي (عند المندوب)": return "warning";
               case "راجع كلي (عند المندوب)": return "danger";
               case "تغيير عنوان": return "secondary";


               default: return "Invalid";
               }
    }
}
