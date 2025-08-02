#ifndef NEWJOURNALENTRYMODEL_H
#define NEWJOURNALENTRYMODEL_H

#include <QQmlEngine>
#include <jsonmodel.h>

class NewJournalEntryModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit NewJournalEntryModel(QObject *parent = nullptr);


    Qt::ItemFlags flags(const QModelIndex& index) const override;

};

#endif // NEWJOURNALENTRYMODEL_H
