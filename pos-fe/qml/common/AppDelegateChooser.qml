import QtQuick;
import QtQuick.Controls.Basic;
import Qt.labs.qmlmodels
import "qrc:/CoreUI/components/tables"
import "qrc:/common";
DelegateChooser{
    role: "delegateType"
    DelegateChoice{ roleValue: "text";       CTableViewDelegate{}}
    DelegateChoice{ roleValue: "currency";   CurrencyDelegate{}}
    DelegateChoice{ roleValue: "percentage"; SuffixDelegate{suffix: "%"}}
    DelegateChoice{ roleValue: "image"; ImageDelegate{}}


}
