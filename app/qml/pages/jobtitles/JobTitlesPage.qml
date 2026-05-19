import QtQuick
import QtQuick.Controls.Basic
import PosFe


CrudViewPage {
    id: page
    title: qsTr("Job Titles")
    delegate: AppDelegateChooser {}
    model: JobTitlesModel{}
    basePath: "qrc:/PosFe/qml/pages/jobtitles";
    formFile: "JobTitleForm.qml"
    addPermission: "prm_add_job_title"
    editPermission: "prm_edit_job_title"
    deletePermission: "prm_remove_job_title"
    deletePath: "jobTitle"
}
