
#include <posapplication.h>
#include <QSettings>
int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("sadeqTech");
    QCoreApplication::setApplicationName("pos-fe");
    PosApplication a(argc, argv);


    return a.exec();
}
