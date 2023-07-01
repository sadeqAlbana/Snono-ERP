#ifndef POSAPPLICATION_H
#define POSAPPLICATION_H

#include <QApplication>
#include <QSettings>
#include <QJsonArray>
#include <QLocale>
class QQmlApplicationEngine;
class AppSettings;
class PosApplication : public QApplication
{
    Q_OBJECT
public:
    PosApplication(int &argc, char **argv);
    ~PosApplication();

    Q_INVOKABLE QVariantList languages() const;
    Q_INVOKABLE QList<QLocale> locales() const;

    QLocale::Language language() const;
    void setLanguage(const QLocale::Language newLanguage);

    void updateAppLanguage();
    void updateAppFont();
    Q_INVOKABLE QStringList availablePrinters();

    void downloadVersion(const int version);

    Q_INVOKABLE static int version();

signals:
    void languageChanged();
    void downloadVersionReply(bool success);

private:
    void initSettings();
    void loadFonts();
    void loadTranslators();
    QList<QTranslator *> m_translators;
    QQmlApplicationEngine *m_engine;
    Q_PROPERTY(QLocale::Language language READ language WRITE setLanguage NOTIFY languageChanged)
};

#endif // POSAPPLICATION_H
