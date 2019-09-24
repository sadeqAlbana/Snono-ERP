#include "debugtab.h"
#include "ui_debugtab.h"

DebugTab::DebugTab(QWidget *parent) :
    QWidget(parent),
    ui(new Ui::DebugTab)
{
    ui->setupUi(this);
}

DebugTab::~DebugTab()
{
    delete ui;
}

