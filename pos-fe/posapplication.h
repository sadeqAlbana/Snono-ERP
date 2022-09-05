#ifndef POSAPPLICATION_H
#define POSAPPLICATION_H

#include <QApplication>
#include <QSettings>

class QQmlApplicationEngine;
class AppSettings;
class PosApplication : public QApplication
{
    Q_OBJECT
public:
    PosApplication(int &argc, char **argv);
    ~PosApplication();

    Q_INVOKABLE QStringList languages() const;
private:
    AppSettings *m_settings;
    void initSettings();
    void loadFonts();
    void loadTranslators();
    QList<QTranslator *> m_translators;

    QQmlApplicationEngine *m_engine;
};

#endif // POSAPPLICATION_H
