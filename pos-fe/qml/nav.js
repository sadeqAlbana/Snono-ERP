.pragma library

function navBar(){
    return [
                {
                    "title": qsTr("Dashboard"),
                    "category":"",
                    "image":"cil-speedometer",
                    "path":"qrc:/pages/dashboard/DashboardPage.qml",
                    "permission": "prm_view_dashboard"
                },
                {
                    "title": qsTr("POS"),
                    "category":qsTr("MAIN"),
                    "image":"cil-screen-desktop",
                    "path":"qrc:/pages/pos/session/SessionsPage.qml",
                    "permission": "prm_purchase_products"
                },
                {
                    "title":qsTr("Accounting"),
                    "category":qsTr("MAIN"),
                    "image":"cil-money",
                    "path":"",
                    "permission": "prm_view_accounts",
                    "childItems":[
                        {
                            "title":qsTr("Accounts"),
                            "path":"qrc:/pages/Accounting/AccountsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Journal Entries"),
                            "path":"qrc:/pages/Accounting/JournalEntriesPage.qml",
                            "permission": "prm_view_journal_entries",

                        },
                        {
                            "title":qsTr("Journal Entries Items"),
                            "path":"qrc:/pages/Accounting/JournalEntriesItemsPage.qml",
                            "permission": "prm_view_journal_entries"
                        }
                    ]
                },

                {
                    "title":qsTr("Products"),
                    "category":qsTr("MAIN"),
                    "image":"cil-inbox",
                    "path":"",
                    "permission": "prm_view_products",
                    "childItems":[
                        {
                            "title":qsTr("Products List"),
                            "path":"qrc:/pages/products/ProductsPage.qml",
                            "permission": "prm_view_full_products"

                        },
                        {
                            "title":qsTr("Mobile List"),
                            "path":"qrc:/pages/products/ProductsMobilePage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Categories"),
                            "path":"qrc:/pages/categories/CategoriesPage.qml",
                            "permission": "prm_view_categories",
                        }
                    ]
                },
                {
                    "title":qsTr("Orders"),
                    "category":qsTr("MAIN"),
                    "image":"cil-pen",
                    "path": "",
                    "permission": "prm_view_orders",
                    "childItems":[
                        {
                            "title":qsTr("Orders List"),
                            "path":"qrc:/pages/orders/OrdersPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Returns"),
                            "path":"qrc:/pages/orders/OrdersReturnsPage.qml",
                            "permission": ""

                        }
                    ]
                },
                {
                    "title":qsTr("Taxes"),
                    "category":qsTr("MAIN"),
                    "image":"cil-money",
                    "path":"qrc:/pages/taxes/TaxesPage.qml",
                    "permission": "prm_view_taxes"

                },
                {
                    "title":qsTr("Customers"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"qrc:/pages/customers/CustomersPage.qml",
                    "permission": "prm_view_customers"
                },
                {
                    "title":qsTr("Vendors"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"",
                    "permission": "prm_view_vendors",
                    "childItems":[
                        {
                            "title":qsTr("Vendors List"),
                            "path":"qrc:/pages/vendors/VendorsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Bills"),
                            "path":"qrc:/pages/vendors/VendorsBillsPage.qml",
                            "permission": "prm_view_vendor_bills"
                        }
                    ]
                },
                {
                    "title":qsTr("Users"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"qrc:/pages/users/UsersPage.qml",
                    "permission": "prm_view_users"
                },
                {
                    "title":qsTr("Reports"),
                    "category":qsTr("MAIN"),
                    "image":"cil-chart",
                    "path":"qrc:/pages/orders/OrdersPage.qml",
                    "permission": "prm_view_reports",
                    "childItems":[
                        {
                            "title":qsTr("Stock"),
                            "path":"qrc:/pages/reports/StockReport.qml",
                            "permission": "prm_view_stock"

                        },
                        {
                            "title":qsTr("Product Sales"),
                            "path":"qrc:/pages/reports/ProductSalesReport.qml",
                            "permission": "prm_view_product_sales"
                        }
                    ]
                },
                {
                    "title":qsTr("Settings"),
                    "category":qsTr("MAIN"),
                    "image":"cil-settings",
                    "path":"",
                    "permission": "",
                    "childItems":[
                        {
                            "title": qsTr("General Settings"),
                            "path": "qrc:/pages/settings/GeneralSettings.qml",
                            "permission": ""
                        },
                        {
                            "title": qsTr("Printer Settings"),
                            "path": "qrc:/pages/settings/PrinterSettings.qml",
                            "permission": ""
                        }
//                        {
//                            "title": qsTr("Server Settings"),
//                            "path": "qrc:/pages/settings/ServerSettings.qml",
//                            "permission": ""
//                        },

//                        {
//                            "title":qsTr("Receipt"),
//                            "path":"qrc:/pages/ReceiptPage.qml",
//                            "permission": ""
//                        }
                    ]
                }
            ];
}


