# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This is the **frontend** half of a paired backend+frontend ERP. The backend lives in the sibling `pos-be-base/` directory. **Read `../CLAUDE.md` first** — it documents the cross-repo coordination rules (which frontend changes require matching backend changes, and the shared API contract).

## Build

CMake + Qt 6 Quick app. Target name is `appposfe`, installed binary is `SnonoErpClient`.

Required Qt 6 components: `Core Quick QuickControls2 Multimedia Gui Network Charts Svg Core5Compat Widgets PrintSupport Location Positioning LinguistTools`, plus `Pdf` and `SerialPort` on desktop (skipped on Android/iOS/WASM).

```bash
# from repo root
cmake -S . -B build
cmake --build build -j
./build/app/appposfe            # or ./build/app/SnonoErpClient after install
./build/app/appposfe --version
```

Submodules under `libs/` (`network-manager`, `CoreUI-QML`, `QGumboParser`, `SCodes`) are pulled from a mix of internal git (`http://git.lan:9080/...`) and GitHub and are already checked out.

Translations: source `language/pos-fe_ar_IQ.ts`, compiled `.qm` files are loaded at runtime from `:/i18n` by `PosApplication::loadTranslators()`.

There is no test suite.

## Architecture

**Entry flow** (`main.cpp` → `PosApplication`):
- `PosApplication` is a `QApplication` subclass that owns a `QQmlApplicationEngine`.
- It registers a small set of singletons as QML context properties on `m_engine->rootContext()` — these are the main bridge between C++ and QML:
  - `App` — `PosApplication` itself (language, version, update download, printer list)
  - `Settings` — `AppSettings::instance()` (`QSettings` over native ini)
  - `AuthManager` — login/logout, current user, permissions
  - `NetworkManager` — `PosNetworkManager::instance()` (the singleton `QNetworkAccessManager`)
  - `Api` — `Api::instance()`, the catch-all of `Q_INVOKABLE` API calls
  - `ReceiptGenerator`, `NumberEditor`, `Clipboard`
- Root QML is loaded from `qrc:/PosFe/qml/main.qml`. QML files are registered via `qt_add_qml_module(appposfe URI "PosFe" …)` in `app/CMakeLists.txt`.

**Auth/session flow**:
- On startup, `main.qml` checks `Settings.jwt`. If present, it calls `AuthManager.testAuth()` (POST `/auth/test`). On success → `AppMainScreen.qml`. On failure → `LoginPage.qml`.
- `AuthManager::authenticate(username, password, remember)` POSTs `/auth/login` with `hw_id` (from `AppSettings::hwID()` — derived from the MAC address) and `version`. The response's `token` is stored in `AppSettings::jwt` and pushed into `PosNetworkManager` as the `Authorization: Bearer …` header.
- Permissions: `AuthManager::reloadPermissions()` flattens `user.acl_group.acl_items` (or legacy `items`) into a `QStringList`. QML gates UI with `AuthManager.hasPermission("prm_xxx")`; `*` is superuser.

**Networking**:
- All API calls go through `PosNetworkManager` (extends a shared `NetworkAccessManager` from the `network-manager` submodule). It sets the base URL from `AppSettings::serverUrl()`, attaches the JWT, and emits `apiReply(status, message)` when responses contain `{status, message}` so QML can toast errors.
- `Api` (`api.cpp`) is a grab-bag of `Q_INVOKABLE` wrappers — each one builds a payload, calls `PosNetworkManager::instance()->post/get(...)`, and either returns a `NetworkResponse*` (caller chains `.subscribe(...)` in QML) or emits a typed signal. **When adding a new backend endpoint, add a matching `Q_INVOKABLE` here** so QML doesn't have to know URL paths.
- List/table views in QML are typically backed by `AppNetworkedJsonModel` subclasses in `app/models/` (one per entity — `usersmodel`, `productsmodel`, `ordersmodel`, …). They POST `{filter, page, count, sortBy, direction}` to a list endpoint and handle pagination/sorting automatically. To add a new list page, subclass `AppNetworkedJsonModel`, register the source in the `qt_add_qml_module` block of `app/CMakeLists.txt`, and consume it from QML.

**Settings** (`appsettings.{h,cpp}`):
- `AppSettings` is a `QSettings` singleton with `Q_PROPERTY`-exposed knobs: server URL, JWT, receipt/label/reports printers & paper sizes, language, receipt branding (company name, phone, bottom note, logo, address QR), test-env flag, etc. Most are bi-directional with QML via property bindings.
- Receipt-side config (logo, company name, address QR, etc.) is pulled from the backend's `/config` endpoint by `AuthManager::reloadSettings()` after every login and saved into `AppSettings` + `storagePath()/assets/receipt_logo.png`.

**Self-update** — `PosApplication::downloadVersion(int)` downloads a `.rcc` resource from `https://software.sadeq.shop/download`, verifies SHA-256 checksums against an embedded `sha256sums.txt`, swaps the binary, and relaunches. Don't touch this path lightly.

## Adding sources / QML files

`app/CMakeLists.txt` is **not** glob-based. New `.cpp/.h` files must be added to either:
- the top `qt_add_executable(appposfe …)` block (core app sources), or
- the `TARGET_SOURCES` list (most C++ models), or
- the `qt_add_qml_module(appposfe …)` block's trailing `SOURCES`/`QML_FILES` entries (new files are often appended here).

New QML files go into `TARGET_QML_SOURCES` (or the trailing `QML_FILES` entries in `qt_add_qml_module`). Android-only / desktop-only variants use the `if(ANDROID) … else() … endif()` block near the bottom of the QML list.

## QML notes

- `import PosFe` exposes app-registered C++ types (models, `AppNetworkedJsonModel`, etc.).
- `import CoreUI`, `import CoreUI.Base`, `import CoreUI.Buttons`, … come from the `CoreUI-QML` submodule.
- RTL/Arabic: `PosApplication::updateAppLanguage()` flips `layoutDirection` based on locale and switches the font to `Hacen Liner Screen` for Arabic. `QML_DISABLE_DISTANCEFIELD=1` is set in `main.cpp` to fix Arabic font artifacts — do not remove.

## Non-obvious conventions (read before you trip on them)

These aren't derivable from any single file — they're cross-cutting tribal knowledge that has bitten previous sessions.

### CoreUI widgets need explicit palettes (or they render as black blocks)
- **`CButton`** with no `palette:` set renders as a dark/black block with invisible text. Always set one (`import CoreUI.Palettes`). Codebase conventions:
  - Primary CTA (Add, Save, main confirm) → `BrandPrimary`
  - Positive/finalize (Post, Pay, Submit) → `BrandSuccess`
  - Edit / secondary info → `BrandInfo`
  - Cancel / Remove / destructive → `BrandDanger`
  - Subtle utility (Today, Clear, "+") → `BrandLight`
- **Use `CComboBox` (from `CoreUI.Forms`), not stock `ComboBox`** — same default-palette problem. The API is identical (`model`, `textRole`, `valueRole`, `currentValue`, `currentIndex`, `onCurrentValueChanged`).

### Consuming "list" endpoints — the `{data:[...]}` wrapper
Backend "list"-type endpoints (`/customer/list`, `/employees/list`, `/jobTitles/list`, `/owners/list` — anything that returns `builder.get(...)` directly) reply with `{"data":[...], "current_page":N, ...}`, **not** a raw array (this is the SORM `Collection` JSON serialization). Extract via `response.json("data")` — assigning plain `response.json()` to a `ComboBox.model` silently fails (the dropdown shows empty because the model sees the wrapper object). Existing example: `qml/pages/invoices/NewInvoicePage.qml:27` (`response.json("data")`).

### `CForm` serialization map (which widgets get auto-serialized)
`CForm` (the base of `CFormView`) walks its children and serializes/deserializes by widget type:

| Widget | Serializes as | JSON type |
|---|---|---|
| `TextInput` / `TextEdit` / `CIconTextField` | `.text` | **string** |
| `CNumberInput` | `.value()` | **double** |
| `T.ComboBox` (incl. `CComboBox`) | `currentValue` | depends on `valueRole` |
| `T.SpinBox` / `T.Slider` / `T.Dial` | `.value` | double |
| `T.Switch` / `T.SwitchDelegate` | `position === 1` | bool |
| `T.CheckBox` | `.checked` | bool |
| `FileInput` / `FolderInput` | selected URL | string |
| `ListView` / `TableView` with `model.toJsonArray()` | that array | array |

Field key is the widget's `objectName`. `CForm` also **recurses into `Layout` and `CPage` children**, so grouping checkboxes inside a `RowLayout` (or putting form fields inside `CTabView` tabs) still serializes correctly. `setInitialValues` mirrors this on load (reads `initialValues[objectName]`).

### Use `CNumberInput` for numeric form fields, not `CIconTextField`
`CIconTextField` serializes as a JSON **string** (it's a `TextInput`). If the backend route declares the param as `QJsonValue::Double` in `requireParams`, the strict-type check rejects the string and the request fails with `parameter 'x' type is Invalid`. For any numeric form field, use `CNumberInput` — `CForm` invokes `.value()` on it which returns a JS number, serializing as a JSON Double. Slapping a `DoubleValidator` on a `CIconTextField` only constrains input; it does **not** change the JSON type at submit time.

### CFormView POST vs PUT
`property string method: keyValue !== null ? "PUT" : "POST"`. So one form file handles both create (`keyValue: null`) and edit (`keyValue: id`); `CrudViewPage` passes `keyValue` automatically on the Edit action. The form posts to its `url` property.

### `Router.navigate(path, params)` param contract
Param keys passed in the second argument become QML properties on the destination page (declared as `property var keyValue`, `property int runId`, `property string title`, etc.). `CrudViewPage` standard actions use `keyValue` for forms; custom navigations pass whatever the target page expects.

### `Api::*` (`api.{h,cpp}`) wrapping convention
Every backend endpoint should have a matching `Q_INVOKABLE` here so QML doesn't hand-roll URL strings — even simple ones. The wrapper either returns `NetworkResponse *` (caller chains `.subscribe(function(res){ var j = res.json(); ... })` in QML) or emits a typed signal for fire-and-forget flows. `res.json()` returns the parsed top-level value; `res.json("key")` returns a specific top-level key.

### `AppNetworkedJsonModel` contract
Constructor signature: `(url, columnList, parent)` where `columnList` entries are either:
- 2-arg short form `{"col", tr("Header")}` — defaults to plain `"text"` delegate.
- 5-arg long form `{"col", tr("Header"), QString(), false, "<delegateType>"}` — picks a typed delegate.

`<delegateType>` values are dispatched by `qml/common/AppDelegateChooser.qml` to: `"text"`, `"currency"` (formats via `Utils.formatCurrency` — **use this for any money column**, otherwise large numbers render in scientific notation like `5e+05`), `"number"`, `"percentage"`, `"image"`, `"date"`, `"datetime"`, `"link"`, `"product_stock"`, `"checkbox"`. Existing examples: `accountsmodel.cpp` (`balance` → currency), `vendorsbillsmodel.cpp` (`total` → currency), `carriersettlementsmodel.cpp`.

For inline (non-column) displays of monetary values in custom pages, import `"qrc:/PosFe/qml/screens/utils.js" as Utils` and use `Utils.formatCurrency(value)` to match.

The model POSTs `{filter, page, count, sortBy, direction}` to `url`; expects either a paginated `Collection` (`{data, current_page, last_page, total}`) or a bare array. Subclass in `app/models/<entity>model.{h,cpp}`, register the sources in the `qt_add_qml_module` block of `app/CMakeLists.txt`.
