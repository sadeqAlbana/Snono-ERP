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
