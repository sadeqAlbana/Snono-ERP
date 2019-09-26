#ifndef NETWORKERRORHANDLER_H
#define NETWORKERRORHANDLER_H

#include <QObject>

class NetworkErrorHandler : public QObject
{
    Q_OBJECT
public:
    explicit NetworkErrorHandler(QObject *parent = nullptr);

    static QWidget *_mainWidget;
};

#endif // NETWORKERRORHANDLER_H
