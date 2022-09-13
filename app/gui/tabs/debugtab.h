#ifndef DEBUGTAB_H
#define DEBUGTAB_H

#include <QWidget>
#include "models/journalentryitemsmodel.h"
namespace Ui {
class DebugTab;
}

class DebugTab : public QWidget
{
    Q_OBJECT

public:
    explicit DebugTab(QWidget *parent = nullptr);
    ~DebugTab();

private:
    Ui::DebugTab *ui;
    JournalEntryItemsModel *model;
};

#endif // DEBUGTAB_H
