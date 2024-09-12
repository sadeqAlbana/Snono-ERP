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
};

#endif // NEWJOURNALENTRYMODEL_H
