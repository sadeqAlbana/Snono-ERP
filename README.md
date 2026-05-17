# Snono ERP — Client

![License](https://img.shields.io/badge/license-GPLv2-blue.svg)
![Qt](https://img.shields.io/badge/Qt-6-41cd52)
![C++](https://img.shields.io/badge/C%2B%2B-17-00599C)
![Platforms](https://img.shields.io/badge/platforms-Linux%20%7C%20Windows%20%7C%20macOS%20%7C%20Android%20%7C%20iOS-lightgrey)

**A fast, touch-friendly desktop and mobile client for running a retail or wholesale business end-to-end.**

`SnonoErpClient` is the Qt 6 / QML frontend for **Snono ERP**. It pairs with the [`pos-be`](https://github.com/sadeqAlbana/Snono-ERP) backend over a JSON API and ships as a single binary that runs on Linux, Windows, macOS, Android and iOS — from a counter-top register to a courier's phone.

---

## Features

### Cashier & Point of Sale
- Barcode-first checkout with on-screen numpad, hotkeys and audible feedback.
- Multiple payment methods per sale, customer selector, drawer / receipt printer wiring.
- Draft orders that park to the backend and recall on any station.
- POS session open / close flow with cash reconciliation.

### Orders & Returns
- In-store and online order screens with live status, sortable / filterable lists and detail pages.
- Partial and full **returns** with a selectable refund liquidity account and automatic refund posting.
- Delivery-status updates and third-party-carrier status mirroring.

### Customers, Drivers & Employees
- Directory pages with search, history and ACL-aware editing.
- Address & phone management, customer-location links, driver ledgers.

### Products & Inventory
- Products with categories, attributes and per-attribute values.
- Multi-location stock, stock moves, reservations and inventory adjustments.
- Catalogue generation, label / barcode printing (Code 128 + QR built in).
- FIFO costing reflected on every sale and return.

### Vendors & Bills
- Vendor directory, custom vendor bills and importers for **Shein** and **AliExpress** orders.
- Bill-payment dialog with liquidity-account selection.

### Accounting
- Chart-of-accounts browser, journal list and journal-entry detail with debit / credit lines.
- Custom journal-entry editor.
- Owner / equity deposit and withdrawal flows.

### Delivery & Shipments
- Shipments list, carrier settlements, carrier payments.
- Integration UIs for **Barq**, **Boxy** and other external carriers.

### Reports & Dashboards
- Sales, inventory, profit and accounting reports with print and PDF export.
- Role-aware home dashboard surfacing the metrics the current user is allowed to see.

### Admin
- Users, ACL groups & items with fine-grained `prm_*` permissions.
- POS machines, payment methods, warehouses / stock locations, taxes.
- Receipt branding (logo, company name, footer note, address QR) pushed live from the server's `/config`.

### Quality of Life
- **Arabic & English** UI with full RTL flip and per-language fonts.
- On-device receipt and label rendering — no separate print server needed.
- **Self-update** over HTTPS: versioned `.rcc` resources verified against embedded SHA-256 checksums, then hot-swapped on relaunch.
- Mobile-aware layout that adapts the cashier and online-order pages to phone form factors.

---

## Tech Stack

- **Qt 6 Quick / QML** — declarative UI, native rendering on every supported platform.
- **C++17** — application core, models and integrations.
- **CMake** — build system.
- Built on the in-tree [`CoreUI-QML`](./libs/CoreUI-QML) component library, [`network-manager`](./libs/network-manager) for HTTP, [`QGumboParser`](./libs/QGumboParser) for HTML scraping (importers), and [`SCodes`](./libs/SCodes) for barcode scanning.

---

## Platforms

| Platform | Status      |
|----------|-------------|
| Linux    | Supported   |
| Windows  | Supported   |
| macOS    | Supported   |
| Android  | Supported   |
| iOS      | Supported   |

Desktop builds additionally pull in Qt's `Pdf` and `SerialPort` modules for PDF export and direct serial-printer / scale support.

---

## Getting Started

```bash
git clone --recursive https://github.com/sadeqAlbana/Snono-ERP.git
cd Snono-ERP/pos-fe-base
cmake -S . -B build
cmake --build build -j
./build/app/appposfe
```

On first launch, open **Server Settings** and point the client at your `pos-be` instance. Log in with a seeded user — the JWT is stored locally and reused on subsequent launches.

---

## License

Snono ERP is released under the **GNU General Public License v2.0**. See the [`LICENSE`](./LICENSE) and [`app/About.md`](./app/About.md) for the full text, including the OpenSSL linking exception.

© Snono Systems.
