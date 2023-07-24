#ifndef CUSTOMJOURNALENTRYMODEL_H
#define CUSTOMJOURNALENTRYMODEL_H

#include <QObject>
#include <jsonmodel.h>
#include <QQmlEngine>

class CustomJournalEntryModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit CustomJournalEntryModel(QObject *parent = nullptr);

signals:

};

#endif // CUSTOMJOURNALENTRYMODEL_H
