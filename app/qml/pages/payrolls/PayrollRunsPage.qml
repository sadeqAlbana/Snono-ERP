import QtQuick
import QtQuick.Controls.Basic
import PosFe
import CoreUI
import CoreUI.Impl
import CoreUI.Base

CrudViewPage {
    id: page
    title: qsTr("Payroll Runs")
    delegate: AppDelegateChooser {}
    model: PayrollRunsModel{}
    basePath: "qrc:/PosFe/qml/pages/payrolls";
    formFile: "PayrollRunForm.qml"
    addPermission: "prm_add_payroll"
    editPermission: "prm_edit_payroll"
    deletePermission: "prm_remove_payroll"
    deletePath: "payrollRun"

    actions: standardActions.concat([openAction])

    property CAction openAction: CAction {
        text: qsTr("Open")
        icon.name: "cil-folder-open"
        enabled: page.view.currentRow >= 0
        onTriggered: Router.navigate(
                         page.basePath+"/PayrollRunDetailsPage.qml", {
                             "title": qsTr("Payroll Run"),
                             "runId": page.model.jsonObject(page.view.currentRow).id
                         })
    }
}
