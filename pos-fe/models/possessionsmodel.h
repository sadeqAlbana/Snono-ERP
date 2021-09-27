#ifndef POSSESSIONSMODEL_H
#define POSSESSIONSMODEL_H

#include "appnetworkedjsonmodel.h"

class PosSessionsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit PosSessionsModel(QObject *parent = nullptr);
    Q_INVOKABLE void newSession();
signals:
    void newSessionResponse(QJsonObject reply);

};

#endif // POSSESSIONSMODEL_H
