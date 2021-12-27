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

ListView {
    model: VendorCartModel{
        id: cartModel

    }

    ProductsModel{
        id: productsModel

        onDataRecevied: {
            var product=jsonObject(0);
            //console.log(JSON.stringify(product))
            var record={
              "product_id" : product.id,
                "qty" : 1,
                "cost" : product.cost
            };
            cartModel.appendRecord(record);
        }
    }

    delegate: RowLayout{
        id: row

        implicitHeight: 50
        implicitWidth: 200

        spacing: 15

        CComboBox{
            id: cb
            Layout.preferredWidth: 250
            implicitWidth: 400
            Layout.fillWidth: true
            textRole: "name"
            valueRole: "id"
            currentIndex: 0
            model: productsModel

        }

        CTextField{
            id: qty
            text: model.qty
            Layout.preferredWidth: 100
            placeholderText: "Quanitity..."
            validator: DoubleValidator{bottom: 0;top:1000000000}
            onTextChanged: {
                console.log(cartModel.setData(model.row,"qty",parseInt(qty.text)));

                updateTotal()

            }
        }
        CTextField{
            id: total;
            Layout.preferredWidth: 150
            text: "0"
            readOnly: true;
        }

        function updateTotal(){
            console.log(model.qty)
            console.log(model.product_id)
            console.log(model.cost)
            total.text=Utils.formatCurrency(model.qty*model.cost);
        }
    }


}
