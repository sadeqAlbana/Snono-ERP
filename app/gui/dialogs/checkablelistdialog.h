#ifndef CHECKABLELISTDIALOG_H
#define CHECKABLELISTDIALOG_H

#include <QDialog>
#include "models/jsonModel/checkablelistmodel.h"
namespace Ui {
class CheckableListDialog;
}

class CheckableListDialog : public QDialog
{
    Q_OBJECT

public:
    explicit CheckableListDialog(const QString &displayColumn,const QString &dataColumn,
                                 QSet<int> original,const QString  &url,QWidget *parent = nullptr);
    ~CheckableListDialog();

    static QJsonArray init(const QString &title,const QString &displayColumn,const QString &dataColumn,
                     QSet<int> original,const QString  &url,QWidget *parent = nullptr);
private:
    Ui::CheckableListDialog *ui;
    void onAccepted();
    CheckableListModel *model;
    QJsonArray returnData;
};

#endif // CHECKABLELISTDIALOG_H
