import QtQuick 2.15
import Qt.labs.qmlmodels 1.0
import "qrc:/CoreUI/components/tables"
import "qrc:/common";
DelegateChooser{
    role: "delegateType"
    DelegateChoice{ roleValue: "text";       CTableViewDelegate{}}
    DelegateChoice{ roleValue: "currency";   CurrencyDelegate{}}
    DelegateChoice{ roleValue: "percentage"; SuffixDelegate{suffix: "%"}}
    DelegateChoice{ roleValue: "image"; ImageDelegate{}}


}
