#ifndef JOURNALENTRIESMODEL_H
#define JOURNALENTRIESMODEL_H

#include "appnetworkedjsonmodel.h"

class JournalEntriesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit JournalEntriesModel(QObject *parent = nullptr);

signals:

};

#endif // JOURNALENTRIESMODEL_H
