#ifndef POSSESSIONSMODEL_H
#define POSSESSIONSMODEL_H

#include "appnetworkedjsonmodel.h"

class PosSessionsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
public:
    explicit PosSessionsModel(QObject *parent = nullptr);
    Q_INVOKABLE void newSession();
    Q_INVOKABLE void closeSession(const int &sessionId);
    Q_INVOKABLE void currentSession();


signals:
    void newSessionResponse(QJsonObject reply);
    void closeSessionResponse(QJsonObject reply);
    void currentSessionResponse(QJsonObject reply);



};

#endif // POSSESSIONSMODEL_H
