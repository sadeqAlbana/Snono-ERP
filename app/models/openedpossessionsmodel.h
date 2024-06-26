#ifndef OPENEDPOSSESSIONSMODEL_H
#define OPENEDPOSSESSIONSMODEL_H

#include "appnetworkedjsonmodel.h"

class OpenedPosSessionsModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit OpenedPosSessionsModel(QObject *parent = nullptr);
    Q_INVOKABLE void newSession();
    Q_INVOKABLE void closeSession(const int &sessionId);
    Q_INVOKABLE void currentSession();


signals:
    void newSessionResponse(QJsonObject reply);
    void closeSessionResponse(QJsonObject reply);
    void currentSessionResponse(QJsonObject reply);



};

#endif // OPENEDPOSSESSIONSMODEL_H
