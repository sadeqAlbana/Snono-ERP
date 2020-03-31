
#include <posapplication.h>
#include <QSettings>
#include <mainwindow.h>

int main(int argc, char *argv[])
{
    QCoreApplication::setOrganizationName("sadeqTech");
    QCoreApplication::setApplicationName("pos-fe");
    QSettings settings;
    PosApplication a(argc, argv);
    a.setStyle("Breeze");

    return a.exec();
}
