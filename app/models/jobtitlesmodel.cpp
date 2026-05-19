#include "jobtitlesmodel.h"

JobTitlesModel::JobTitlesModel(QObject *parent) : AppNetworkedJsonModel("/jobTitles",{
                                         {"id",tr("ID")} ,
                                         {"name",tr("Name")} ,
                                         {"default_salary",tr("Default Salary"),QString(),false,"currency"} ,},parent)
{

}
