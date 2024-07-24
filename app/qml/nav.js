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
                   "title": qsTr("Sales"),
                   "category":qsTr("MAIN"),
                   "image":"cil-screen-desktop",
                   "path":"",
                         "childItems":[
                            {
                               "title":qsTr("POS"),
                               "image":"cil-barcode",
                               "path":"qrc:/PosFe/qml/pages/pos/session/SessionsPage.qml"
                            },
                            {
                               "title":qsTr("Online"),
                               "image":"cil-globe",

                               "path":"qrc:/PosFe/qml/pages/cashier/NewOnlineOrderPage.qml"
                            },
                        {
                           "title":qsTr("POS Sessions"),
                           "path":"qrc:/PosFe/qml/pages/pos/PosSessionsPage.qml"
                        },
                         ]
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
                        },
                        {
                            "title":qsTr("Attributes"),
                            "path":"qrc:/PosFe/qml/pages/products/ProductAttributesPage.qml",
                            "permission": "prm_view_product_attributes",
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
                            "title":qsTr("All Orders"),
                            "image":"cil-cart-loaded",
                            "path":"qrc:/PosFe/qml/pages/orders/OrdersPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("POS"),
                            "image":"cil-barcode",
                            "path":"qrc:/PosFe/qml/pages/orders/PosOrdersPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Online Orders"),
                            "path":"qrc:/PosFe/qml/pages/orders/OnlineOrdersPage.qml",
                            "permission": "",
                            "image":"cil-globe",

                        },
                        {
                            "title":qsTr("Returns"),
                            "image":"cil-cart-slash",
                            "path":"qrc:/PosFe/qml/pages/orders/OrdersReturnsPage.qml",
                            "permission": ""

                        },
                        {
                            "title":qsTr("Drafts"),
                            "image":"cil-notes",
                            "path":"qrc:/PosFe/qml/pages/orders/DraftOrdersPage.qml",
                            "permission": "prm_view_draft_orders",
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
                    "title":qsTr("Locations"),
                    "category":qsTr("MAIN"),
                    "image":"cil-location-pin",
                    "path":"qrc:/PosFe/qml/pages/locations/LocationsPage.qml",
                    "permission": "prm_view_customers"
                },
                {
                    "title":qsTr("Delivery"),
                    "category":qsTr("MAIN"),
                    "image":"cil-user",
                    "path":"",
                    "permission": "prm_view_deliveries",
                    "childItems":[
                        {
                            "title":qsTr("Drivers List"),
                            "path":"qrc:/PosFe/qml/pages/delivery/DriversPage.qml",
                            "permission": "prm_view_drivers"
                        },
                        {
                            "title":qsTr("Shipments"),
                            "path":"qrc:/PosFe/qml/pages/delivery/ShipmentsPage.qml",
                            "permission": "prm_view_shipments"
                        },

                    ]
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
                   "title":qsTr("Warehouses"),
                   "category":qsTr("MAIN"),
                   "image":"cil-home",
                    "childItems":[
                        {
                            "title":qsTr("List"),
                            "path":"qrc:/PosFe/qml/pages/warehouses/WarehousesPage.qml",
                            "permission": "prm_view_warehouse"

                        },
                        {
                            "title":qsTr("Stock Moves"),
                            "path":"qrc:/PosFe/qml/pages/warehouses/StockMovesPage.qml",
                            "permission": "prm_view_stock_moves"
                        },
                        {
                            "title":qsTr("Stock Valuation"),
                            "path":"qrc:/PosFe/qml/pages/warehouses/StockValuationPage.qml",
                            "permission": "prm_view_stock_valuation"
                        }
                    ]
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
                    "path":"",
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
                        },
                        {
                            "title":qsTr("Orders Sales"),
                            "path":"qrc:/PosFe/qml/pages/reports/OrdersSalesReportPage.qml",
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
                            "title": qsTr("Devices"),
                            "path":"qrc:/PosFe/qml/pages/settings/PosMachinesPage.qml",
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
                        },
                        {
                            "title": qsTr("License"),
                            "path":"qrc:/PosFe/qml/pages/settings/LicensePage.qml",
                            "permission": "prm_admin"
                        },
                        {
                            "title": qsTr("About"),
                            "path":"qrc:/PosFe/qml/pages/settings/AboutPage.qml",
                            "permission": ""
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


