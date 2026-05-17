import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Employees")
    delegate: AppDelegateChooser {}
    model: EmployeesModel{}
    basePath: "qrc:/PosFe/qml/pages/employees";
    formFile: "EmployeeForm.qml"
    addPermission: "prm_add_employee"
    editPermission: "prm_edit_employee"
    deletePermission: "prm_remove_employee"
    deletePath: "employee"
}
