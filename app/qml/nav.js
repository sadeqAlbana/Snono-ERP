.pragma library

function navBar(){
    return [
                {
                    "title": qsTr("Dashboard"),
                    "category":"",
                    "image":"cil-speedometer",
                    "path":"qrc:/PosFe/qml/pages/dashboard/DashboardPage.qml",
                    "permission": "prm_view_dashboard",
                },
                {
                    "title": qsTr("POS"),
                    "category":qsTr("MAIN"),
                    "image":"cil-screen-desktop",
                    "path":"qrc:/PosFe/qml/pages/pos/session/SessionsPage.qml",
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
                            "path":"qrc:/PosFe/qml/pages/Accounting/AccountsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Journal Entries"),
                            "path":"qrc:/PosFe/qml/pages/Accounting/JournalEntriesPage.qml",
                            "permission": "prm_view_journal_entries",

                        },
                        {
                            "title":qsTr("Journal Entries Items"),
                            "path":"qrc:/PosFe/qml/pages/Accounting/JournalEntriesItemsPage.qml",
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
                            "path":"qrc:/PosFe/qml/pages/products/ProductsPage.qml",
                            "permission": "prm_view_full_products"

                        },
                        {
                            "title":qsTr("Mobile List"),
                            "path":"qrc:/PosFe/qml/pages/products/ProductsMobilePage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Categories"),
                            "path":"qrc:/PosFe/qml/pages/categories/CategoriesPage.qml",
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
                            "path":"qrc:/PosFe/qml/pages/orders/OrdersPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Returns"),
                            "path":"qrc:/PosFe/qml/pages/orders/OrdersReturnsPage.qml",
                            "permission": ""

                        }
                    ]
                },
                {
                    "title":qsTr("Taxes"),
                    "category":qsTr("MAIN"),
                    "image":"cil-money",
                    "path":"qrc:/PosFe/qml/pages/taxes/TaxesPage.qml",
                    "permission": "prm_view_taxes"

                },
                {
                    "title":qsTr("Customers"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"qrc:/PosFe/qml/pages/customers/CustomersPage.qml",
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
                            "path":"qrc:/PosFe/qml/pages/vendors/VendorsPage.qml",
                            "permission": ""
                        },
                        {
                            "title":qsTr("Bills"),
                            "path":"qrc:/PosFe/qml/pages/vendors/VendorsBillsPage.qml",
                            "permission": "prm_view_vendor_bills"
                        }
                    ]
                },
                {
                    "title":qsTr("Users"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"qrc:/PosFe/qml/pages/users/UsersPage.qml",
                    "permission": "prm_view_users"
                },
                {
                    "title":qsTr("Permissions"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"qrc:/PosFe/qml/pages/users/PermissionsPage.qml",
                    "permission": "prm_view_users"
                },
                {
                    "title":qsTr("Reports"),
                    "category":qsTr("MAIN"),
                    "image":"cil-chart",
                    "path":"qrc:/PosFe/qml/pages/orders/OrdersPage.qml",
                    "permission": "prm_view_reports",
                    "childItems":[
                        {
                            "title":qsTr("Stock"),
                            "path":"qrc:/PosFe/qml/pages/reports/StockReport.qml",
                            "permission": "prm_view_stock"

                        },
                        {
                            "title":qsTr("Product Sales"),
                            "path":"qrc:/PosFe/qml/pages/reports/ProductSalesReport.qml",
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
                            "path":"qrc:/PosFe/qml/pages/settings/GeneralSettings.qml",
                            "permission": ""
                        },
                        {
                            "title": qsTr("Identity Settings"),
                            "path":"qrc:/PosFe/qml/pages/settings/IdentitySettings.qml",
                            "permission": "prm_admin"
                        },
                        {
                            "title": qsTr("Receipt Settings"),
                            "path":"qrc:/PosFe/qml/pages/settings/ReceiptSettings.qml",
                            "permission": "prm_admin"
                        },
                        {
                            "title": qsTr("Printer Settings"),
                            "path":"qrc:/PosFe/qml/pages/settings/PrinterSettings.qml",
                            "permission": ""
                        },
                        {
                            "title": qsTr("Barq Delivery"),
                            "path":"qrc:/PosFe/qml/pages/settings/BarqDeliverySettings.qml",
                            "permission": "prm_admin"
                        }
//                        {
//                            "title": qsTr("Server Settings"),
//                            "path":"qrc:/PosFe/qml/pages/settings/ServerSettings.qml",
//                            "permission": ""
//                        },

//                        {
//                            "title":qsTr("Receipt"),
//                            "path":"qrc:/PosFe/qml/pages/ReceiptPage.qml",
//                            "permission": ""
//                        }
                    ]
                }
            ];
}


