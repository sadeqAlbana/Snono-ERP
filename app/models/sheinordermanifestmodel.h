#ifndef SHEINORDERMANIFESTMODEL_H
#define SHEINORDERMANIFESTMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <jsonmodel.h>

class SheinOrderManifestModel : public JsonModel
{
    Q_OBJECT
    QML_ELEMENT
public:
    explicit SheinOrderManifestModel(QObject *parent = nullptr);
};

#endif // SHEINORDERMANIFESTMODEL_H
