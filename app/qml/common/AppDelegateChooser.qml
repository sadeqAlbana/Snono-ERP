import QtQuick;
import QtQuick.Controls.Basic;
import Qt.labs.qmlmodels
import CoreUI
import CoreUI.Views
DelegateChooser{
    role: "delegateType"
    DelegateChoice{ roleValue: "text";       CTableViewDelegate{}}
    DelegateChoice{ roleValue: "currency";   CurrencyDelegate{}}
    DelegateChoice{ roleValue: "number";     NumberDelegate{}}
    DelegateChoice{ roleValue: "percentage"; PercentageDelegate{}}
    DelegateChoice{ roleValue: "image"; ImageDelegate{}}
    DelegateChoice{ roleValue: "date"; DateDelegate{}}
    DelegateChoice{ roleValue: "datetime"; DateTimeDelegate{}}
    DelegateChoice{ roleValue: "link"; LinkDelegate{}}
    DelegateChoice{ roleValue: "product_stock"; ProductStockDelegate{}}

}
