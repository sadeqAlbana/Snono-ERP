.pragma library

var navBarData=[
   {
      "title": qsTr("Dashboard"),
      "category":"",
      "image":"cil-speedometer",
      "path":"qrc:/pages/dashboard/DashboardPage.qml"
   },
   {
      "title": qsTr("POS"),
      "category":qsTr("MAIN"),
      "image":"cil-screen-desktop",
      "path":"qrc:/pages/pos/session/SessionsPage.qml"
   },
   {
      "title":qsTr("Accounting"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Accounts"),
            "path":"qrc:/pages/Accounting/AccountsPage.qml"
         },
         {
            "title":qsTr("Journal Entries"),
            "path":"qrc:/pages/Accounting/JournalEntriesPage.qml"
         },
         {
            "title":qsTr("Journal Entries Items"),
            "path":"qrc:/pages/Accounting/JournalEntriesItemsPage.qml"
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
            "path":"qrc:/pages/products/ProductsPage.qml"
         },
         {
            "title":qsTr("Mobile List"),
            "path":"qrc:/pages/products/ProductsMobilePage.qml"
         },
         {
            "title":qsTr("Categories"),
            "path":"qrc:/pages/categories/CategoriesPage.qml"
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
            "path":"qrc:/pages/orders/OrdersPage.qml"
         },
         {
            "title":qsTr("Returns"),
            "path":"qrc:/pages/orders/OrdersReturnsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Taxes"),
      "category":qsTr("MAIN"),
      "image":"cil-money",
      "path":"qrc:/pages/taxes/TaxesPage.qml"
   },
   {
      "title":qsTr("Customers"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"qrc:/pages/customers/CustomersPage.qml"
   },
   {
      "title":qsTr("Vendors"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"",
      "childItems":[
         {
            "title":qsTr("Vendors List"),
            "path":"qrc:/pages/vendors/VendorsPage.qml"
         },
         {
            "title":qsTr("Bills"),
            "path":"qrc:/pages/vendors/VendorsBillsPage.qml"
         }
      ]
   },
   {
      "title":qsTr("Users"),
      "category":qsTr("MAIN"),
      "image":"cil-user",
      "path":"qrc:/pages/users/UsersPage.qml"
   },
   {
      "title":qsTr("Reports"),
      "category":qsTr("MAIN"),
      "image":"cil-chart",
      "path":"qrc:/pages/orders/OrdersPage.qml",
      "childItems":[
         {
            "title":qsTr("Stock"),
            "path":"qrc:/pages/reports/StockReport.qml"
         },
         {
            "title":qsTr("Product Sales"),
            "path":"qrc:/pages/reports/ProductSalesReport.qml"
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
                        "path": "qrc:/pages/settings/GeneralSettings.qml"
                    },
                    {
                        "title": qsTr("Printer Settings"),
                        "path": "qrc:/pages/settings/ServerSettings.qml"
                    },
                    {
                        "title": qsTr("Server Settings"),
                        "path": "qrc:/pages/settings/ServerSettings.qml"
                    },

         {
            "title":qsTr("Receipt"),
            "path":"qrc:/pages/ReceiptPage.qml"
         }
      ]
   }
];
