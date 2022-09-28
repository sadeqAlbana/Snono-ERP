pragma Singleton
import QtQuick

QtObject{
property var navBarData: [
   {
      "title": qsTr("Dashboard"),
      "category":"",
      "image":"cil-speedometer",
      "path":"pages/dashboard/DashboardPage.qml"
   },
   {
      "title": qsTr("POS"),
      "category":qsTr("MAIN"),
      "image":"cil-screen-desktop",
      "path":"pages/pos/session/SessionsPage.qml"
   },
   {
      "title":qsTr("Accounting"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Accounts"),
            "path":"pages/Accounting/AccountsPage.qml"
         },
         {
            "title":qsTr("Journal Entries"),
            "path":"pages/Accounting/JournalEntriesPage.qml"
         },
         {
            "title":qsTr("Journal Entries Items"),
            "path":"pages/Accounting/JournalEntriesItemsPage.qml"
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
            "path":"pages/products/ProductsPage.qml"
         },
         {
            "title":qsTr("Mobile List"),
            "path":"pages/products/ProductsMobilePage.qml"
         },
         {
            "title":qsTr("Categories"),
            "path":"pages/categories/CategoriesPage.qml"
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
            "path":"pages/orders/OrdersPage.qml"
         },
         {
            "title":qsTr("Returns"),
            "path":"pages/orders/OrdersReturnsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Taxes"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"pages/taxes/TaxesPage.qml"
   },
   {
      "title":qsTr("Customers"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"pages/customers/CustomersPage.qml"
   },
   {
      "title":qsTr("Vendors"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Vendors List"),
            "path":"pages/vendors/VendorsPage.qml"
         },
         {
            "title":qsTr("Bills"),
            "path":"pages/vendors/VendorsBillsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Users"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"pages/users/UsersPage.qml"
   },
   {
      "title":qsTr("Reports"),
      "category":qsTr("MAIN"),
      "image":"cil-chart",
      "path":"pages/orders/OrdersPage.qml",
      "childItems":[
         {
            "title":qsTr("Stock"),
            "path":"pages/reports/StockReport.qml"
         },
         {
            "title":qsTr("Product Sales"),
            "path":"pages/reports/ProductSalesReport.qml"
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
                        "path": "pages/settings/GeneralSettings.qml"
                    },
                    {
                        "title": qsTr("Printer Settings"),
                        "path": "pages/settings/ServerSettings.qml"
                },
                    {
                        "title": qsTr("Server Settings"),
                        "path": "pages/settings/ServerSettings.qml"
                    },

         {
            "title":qsTr("Receipt"),
            "path":"pages/ReceiptPage.qml"
         }
      ]
   }
];

}
