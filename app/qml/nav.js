.pragma library

function navBar(){
    return [
                {
                    "title": qsTr("Dashboard"),
                    "category":"",
                    "image":"cil-speedometer",
                    "path":"pages/dashboard/DashboardPage.qml",
                    "permission": "prm_view_dashboard"
                },
                {
                    "title": qsTr("POS"),
                    "category":qsTr("MAIN"),
                    "image":"cil-screen-desktop",
                    "path":"pages/pos/session/SessionsPage.qml",
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
                            "path":"pages/Accounting/AccountsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Journal Entries"),
                            "path":"pages/Accounting/JournalEntriesPage.qml",
                            "permission": "prm_view_journal_entries",

                        },
                        {
                            "title":qsTr("Journal Entries Items"),
                            "path":"pages/Accounting/JournalEntriesItemsPage.qml",
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
                            "path":"pages/products/ProductsPage.qml",
                            "permission": "prm_view_full_products"

                        },
                        {
                            "title":qsTr("Mobile List"),
                            "path":"pages/products/ProductsMobilePage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Categories"),
                            "path":"pages/categories/CategoriesPage.qml",
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
                            "path":"pages/orders/OrdersPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Returns"),
                            "path":"pages/orders/OrdersReturnsPage.qml",
                            "permission": ""

                        }
                    ]
                },
                {
                    "title":qsTr("Taxes"),
                    "category":qsTr("MAIN"),
                    "image":"cil-money",
                    "path":"pages/taxes/TaxesPage.qml",
                    "permission": "prm_view_taxes"

                },
                {
                    "title":qsTr("Customers"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"pages/customers/CustomersPage.qml",
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
                            "path":"pages/vendors/VendorsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Bills"),
                            "path":"pages/vendors/VendorsBillsPage.qml",
                            "permission": "prm_view_vendor_bills"
                        }
                    ]
                },
                {
                    "title":qsTr("Users"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"pages/users/UsersPage.qml",
                    "permission": "prm_view_users"
                },
                {
                    "title":qsTr("Reports"),
                    "category":qsTr("MAIN"),
                    "image":"cil-chart",
                    "path":"pages/orders/OrdersPage.qml",
                    "permission": "prm_view_reports",
                    "childItems":[
                        {
                            "title":qsTr("Stock"),
                            "path":"pages/reports/StockReport.qml",
                            "permission": "prm_view_stock"

                        },
                        {
                            "title":qsTr("Product Sales"),
                            "path":"pages/reports/ProductSalesReport.qml",
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
                            "path": "pages/settings/GeneralSettings.qml",
                            "permission": ""
                        },
                        {
                            "title": qsTr("Printer Settings"),
                            "path": "pages/settings/PrinterSettings.qml",
                            "permission": ""
                        }
//                        {
//                            "title": qsTr("Server Settings"),
//                            "path": "pages/settings/ServerSettings.qml",
//                            "permission": ""
//                        },

//                        {
//                            "title":qsTr("Receipt"),
//                            "path":"pages/ReceiptPage.qml",
//                            "permission": ""
//                        }
                    ]
                }
            ];
}


