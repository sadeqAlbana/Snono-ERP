#ifndef JOBTITLESMODEL_H
#define JOBTITLESMODEL_H

#include <QQmlEngine>
#include "appnetworkedjsonmodel.h"

class JobTitlesModel : public AppNetworkedJsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit JobTitlesModel(QObject *parent = nullptr);
};

#endif // JOBTITLESMODEL_H
