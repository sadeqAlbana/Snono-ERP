pragma Singleton
import QtQuick

QtObject{
property var navBarData: [
   {
      "title": qsTr("Dashboard"),
      "category":"",
      "image":"cil-speedometer",
      "path":"qrc:/PosFe/qml/pages/dashboard/DashboardPage.qml"
   },
   {
      "title": qsTr("POS"),
      "category":qsTr("MAIN"),
      "image":"cil-screen-desktop",
      "path":"qrc:/PosFe/qml/pages/pos/session/SessionsPage.qml"
   },
   {
      "title":qsTr("Accounting"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Accounts"),
            "path":"qrc:/PosFe/qml/pages/Accounting/AccountsPage.qml"
         },
         {
            "title":qsTr("Journal Entries"),
            "path":"qrc:/PosFe/qml/pages/Accounting/JournalEntriesPage.qml"
         },
         {
            "title":qsTr("Journal Entries Items"),
            "path":"qrc:/PosFe/qml/pages/Accounting/JournalEntriesItemsPage.qml"
         }
      ]
   },

   {
      "title":qsTr("Products"),
      "category":qsTr("MAIN"),
      "image":"cil-inbox",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Products List"),
            "path":"qrc:/PosFe/qml/pages/products/ProductsPage.qml"
         },
         {
            "title":qsTr("Mobile List"),
            "path":"qrc:/PosFe/qml/pages/products/ProductsMobilePage.qml"
         },
         {
            "title":qsTr("Categories"),
            "path":"qrc:/PosFe/qml/pages/categories/CategoriesPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Orders"),
      "category":qsTr("MAIN"),
      "image":"cil-pen",
      "path": "",
      "childItems":[
         {
            "title":qsTr("Orders List"),
            "path":"qrc:/PosFe/qml/pages/orders/OrdersPage.qml"
         },
         {
            "title":qsTr("Returns"),
            "path":"qrc:/PosFe/qml/pages/orders/OrdersReturnsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Taxes"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"qrc:/PosFe/qml/pages/taxes/TaxesPage.qml"
   },
   {
      "title":qsTr("Customers"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"qrc:/PosFe/qml/pages/customers/CustomersPage.qml"
   },
   {
      "title":qsTr("Vendors"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Vendors List"),
            "path":"qrc:/PosFe/qml/pages/vendors/VendorsPage.qml"
         },
         {
            "title":qsTr("Bills"),
            "path":"qrc:/PosFe/qml/pages/vendors/VendorsBillsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Users"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"qrc:/PosFe/qml/pages/users/UsersPage.qml"
   },
   {
      "title":qsTr("Reports"),
      "category":qsTr("MAIN"),
      "image":"cil-chart",
      "path":"qrc:/PosFe/qml/pages/orders/OrdersPage.qml",
      "childItems":[
         {
            "title":qsTr("Stock"),
            "path":"qrc:/PosFe/qml/pages/reports/StockReport.qml"
         },
         {
            "title":qsTr("Product Sales"),
            "path":"qrc:/PosFe/qml/pages/reports/ProductSalesReport.qml"
         }
      ]
   },
   {
      "title":qsTr("Settings"),
      "category":qsTr("MAIN"),
      "image":"cil-settings",
      "path":"",
      "childItems":[
                    {
                        "title": qsTr("General Settings"),
                        "path":"qrc:/PosFe/qml/pages/settings/GeneralSettings.qml"
                    },
                    {
                        "title": qsTr("Printer Settings"),
                        "path":"qrc:/PosFe/qml/pages/settings/ServerSettings.qml"
                },
                    {
                        "title": qsTr("Server Settings"),
                        "path":"qrc:/PosFe/qml/pages/settings/ServerSettings.qml"
                    },

         {
            "title":qsTr("Receipt"),
            "path":"qrc:/PosFe/qml/pages/ReceiptPage.qml"
         }
      ]
   }
];

}
