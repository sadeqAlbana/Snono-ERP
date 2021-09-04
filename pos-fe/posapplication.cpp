#include "posapplication.h"
#include <QDebug>

PosApplication::PosApplication(int &argc, char **argv) : QApplication(argc, argv)
{
    initSettings();
}

PosApplication::~PosApplication()
{

}

void PosApplication::initSettings()
{
    qDebug()<<"init settings";
}
