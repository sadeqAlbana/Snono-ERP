#include "appsettings.h"
#include <QUrl>
#include <QDebug>
#include <QCoreApplication>
#include <QJsonDocument>
#include <QNetworkInterface>
#include <QUuid>
#include <QStandardPaths>
#include <QSizeF>
#include <QFile>
AppSettings* AppSettings::m_instance;

AppSettings::AppSettings(QObject *parent) : QSettings(parent)
{

}

AppSettings *AppSettings::instance()
{
    if(!m_instance)
        m_instance= new AppSettings(qApp);
    return m_instance;
}

QByteArray AppSettings::jwt() const
{
    return value("jwt").toByteArray();
}

void AppSettings::setJwt(const QByteArray &newJwt)
{
    if (jwt() == newJwt)
        return;
    setValue("jwt",newJwt);
    emit jwtChanged();
}

QString AppSettings::macAddress()
{
#ifndef Q_OS_WASM
        for(QNetworkInterface netInterface: QNetworkInterface::allInterfaces())
        {
            // Return only the first non-loopback MAC Address
            if (!(netInterface.flags() & QNetworkInterface::IsLoopBack))
                return netInterface.hardwareAddress();
        }
#endif
        return QString();

}

QByteArray AppSettings::deviceUuid()
{
    QByteArray value=instance()->value("uuid").toByteArray();
    if(value.isEmpty()){
        QUuid uuid=QUuid::createUuid();
        instance()->setValue("uuid",uuid.toByteArray(QUuid::WithoutBraces));
        value=instance()->value("uuid").toByteArray();
    }
    return value;
}

int AppSettings::receiptCopies() const
{
    return value("receipt_copies",1).toInt();
}

QString AppSettings::storagePath()
{
    return QStandardPaths::standardLocations(QStandardPaths::AppDataLocation).value(0);
}

void AppSettings::setReceiptCopies(int newReceiptCopies)
{
    if (receiptCopies() == newReceiptCopies)
        return;
    setValue("receipt_copies", newReceiptCopies);
    emit receiptCopiesChanged();
}

int AppSettings::externalReceiptCopies() const
{
    return value("external_receipt_copies",3).toInt();
}

void AppSettings::setExternalReceiptCopies(int newExternalReceiptCopies)
{
    if (externalReceiptCopies() == newExternalReceiptCopies)
        return;
    setValue("external_receipt_copies", newExternalReceiptCopies);
    emit externalReceiptCopiesChanged();
}

bool AppSettings::externalDelivery() const
{
    return value("external_delivery",false).toBool();
}

void AppSettings::setExternalDelivery(bool newExternalDelivery)
{
    if (externalDelivery() == newExternalDelivery)
        return;
    setValue("external_delivery", newExternalDelivery);
    emit externalDeliveryChanged();
}

void AppSettings::setReceiptCompanyName(const QString &name)
{
    setValue("receipt/receipt_company_name",name);
}

void AppSettings::setReceiptPhoneNumber(const QString &phoneNumber)
{
    setValue("receipt/receipt_phone",phoneNumber);
}

void AppSettings::setReceiptBottomNote(const QString &bottomNote)
{
    setValue("receipt/receipt_bottom_note",bottomNote);
}

QString AppSettings::receiptCompanyName() const
{
    return value("receipt/receipt_company_name").toString();
}

QString AppSettings::receiptPhoneNumber() const
{
    return value("receipt/receipt_phone").toString();

}

QString AppSettings::receiptBottomNote() const
{
    return value("receipt/receipt_bottom_note").toString();

}



QString AppSettings::platform()
{
    return QString("%1-%2").arg(QSysInfo::kernelType(),QSysInfo::buildCpuArchitecture());
}

int AppSettings::version()
{
    return APP_VERSION;
}

QString AppSettings::receiptPrinter() const
{
    return value("receipt_printer","Default Printer").toString();
}

void AppSettings::setReceiptPrinter(const QString &newReceiptPrinter)
{
    if (receiptPrinter() == newReceiptPrinter)
        return;
    setValue("receipt_printer",newReceiptPrinter);
    emit receiptPrinterChanged();
}

QString AppSettings::reportsPrinter() const
{
    return value("reports_printer","Default Printer").toString();
}

void AppSettings::setReportsPrinter(const QString &newReportsPrinter)
{
    if (reportsPrinter() == newReportsPrinter)
        return;
    setValue("reports_printer",newReportsPrinter);
    emit reportsPrinterChanged();
}

QString AppSettings::receiptPaperSize() const
{
    return value("receipt_paper_size","A4").toString();
}

void AppSettings::setReceiptPaperSize(const QString &newReceiptPaperSize)
{
    if (receiptPaperSize() == newReceiptPaperSize)
        return;
    setValue("receipt_paper_size",newReceiptPaperSize);
    emit receiptPaperSizeChanged();
}

QString AppSettings::reportsPaperSize() const
{
    return value("reports_paper_size","A4").toString();
}

void AppSettings::setReportsPaperSize(const QString &newReportsPaperSize)
{
    if (reportsPaperSize() == newReportsPaperSize)
        return;
    setValue("reports_paper_size",newReportsPaperSize);
    emit reportsPaperSizeChanged();
}

QPageSize AppSettings::pageSizeFromString(const QString &pageSize)
{
    if(pageSize=="A0")
        return QPageSize::A0;

    if(pageSize=="A1")
        return QPageSize::A1;

    if(pageSize=="A2")
        return QPageSize::A2;

    if(pageSize=="A3")
        return QPageSize::A3;

    if(pageSize=="A4")
        return QPageSize::A4;

    if(pageSize=="A5")
        return QPageSize::A5;

    if(pageSize=="A6")
        return QPageSize::A6;

    if(pageSize=="A7")
        return QPageSize::A7;

    if(pageSize=="57mm"){
        return QPageSize(QSizeF(57,210),QPageSize::Millimeter,"57mm");
    }
    if(pageSize=="58mm"){
        return QPageSize(QSizeF(58,210),QPageSize::Millimeter,"58mm");

    }
    if(pageSize=="78mm"){
        return QPageSize(QSizeF(78,210),QPageSize::Millimeter,"78mm");

    }
    if(pageSize=="80mm"){
        return QPageSize(QSizeF(80,210),QPageSize::Millimeter,"80mm");

    }

    return QPageSize::Custom;
}

QPageSize::Unit AppSettings::pageSizeUnitFromString(const QString &unit)
{
    if(unit=="Millimeter")
        return QPageSize::Unit::Millimeter;

    if(unit=="Point")
        return QPageSize::Unit::Point;

    if(unit=="Inch")
        return QPageSize::Unit::Inch;

    if(unit=="Pica")
        return QPageSize::Unit::Pica;

    if(unit=="Didot")
        return QPageSize::Unit::Didot;

    if(unit=="Cicero")
        return QPageSize::Unit::Cicero;


    return QPageSize::Unit::Millimeter;
}

QJsonArray AppSettings::qPageSizeUnits()
{
    return QJsonArray{
        QJsonObject{{"key",tr("Millimeter")},{"value",QPageSize::Unit::Millimeter}},
        QJsonObject{{"key",tr("Point")},{"value",QPageSize::Unit::Point}},
        QJsonObject{{"key",tr("Inch")},{"value",QPageSize::Unit::Inch}},
        QJsonObject{{"key",tr("Pica")},{"value",QPageSize::Unit::Pica}},
        QJsonObject{{"key",tr("Didot")},{"value",QPageSize::Unit::Didot}},
        QJsonObject{{"key",tr("Cicero")},{"value",QPageSize::Unit::Cicero}},
    };
}

bool AppSettings::receiptLinePrinter() const
{
    return value("receipt_line_printer",true).toBool();
}

void AppSettings::setReceiptLinePrinter(bool newReceiptLinePrinter)
{
    if (receiptLinePrinter() == newReceiptLinePrinter)
        return;
    setValue("receipt_line_printer",newReceiptLinePrinter);
    emit receiptLinePrinterChanged();
}

int AppSettings::receiptCopiesWithExternalDelivery() const
{
    return value("receipt_copies_with_external_delivery",1).toInt();
}

void AppSettings::setReceiptCopiesWithExternalDelivery(int newReceiptCopiesWithExternalDelivery)
{
    if (receiptCopiesWithExternalDelivery() == newReceiptCopiesWithExternalDelivery)
        return;
    setValue("receipt_copies_with_external_delivery", newReceiptCopiesWithExternalDelivery);
    emit receiptCopiesWithExternalDeliveryChanged();
}

QVariant AppSettings::get(const QString &key, QVariant defaultValue)
{
    return value(key,defaultValue);
}

void AppSettings::set(const QString &key, const QVariant &value)
{
    setValue(key,value);
}

QString AppSettings::labelPrinter() const
{
    return value("label_printer","").toString();
}

void AppSettings::setLabelPrinter(const QString &newLabelPrinter)
{
    if (labelPrinter() == newLabelPrinter)
        return;
    setValue("label_printer",newLabelPrinter);
    emit labelPrinterChanged();
}

bool AppSettings::testEnv() const
{
    return m_testEnv;
}

void AppSettings::setTestEnv(bool newTestEnv)
{
    if (m_testEnv == newTestEnv)
        return;
    m_testEnv = newTestEnv;
    emit testEnvChanged();
}

QString AppSettings::posReceiptBottomNote() const
{
    return value("receipt/receipt_pos_bottom_note",1).toString();
}

void AppSettings::setPosReceiptBottomNote(const QString &newPosReceiptBottomNote)
{
    if (posReceiptBottomNote() == newPosReceiptBottomNote)
        return;

    setValue("receipt/receipt_pos_bottom_note",newPosReceiptBottomNote);
    emit posReceiptBottomNoteChanged();
}

QString AppSettings::linePrinter() const
{
    return value("line_printer","Default Printer").toString();
}

void AppSettings::setLinePrinter(const QString &newLinePrinter)
{
    if (linePrinter() == newLinePrinter)
        return;
    setValue("line_printer",newLinePrinter);
    emit linePrinterChanged();
}

QString AppSettings::linePrinterPaperSize() const
{
    return value("line_printer_paper_size","80mm").toString();
}

void AppSettings::setLinePrinterPaperSize(const QString &newLinePrinterPaperSize)
{
    if (linePrinterPaperSize() == newLinePrinterPaperSize)
        return;
    setValue("line_printer_paper_size",newLinePrinterPaperSize);
    emit linePrinterPaperSizeChanged();
}


float AppSettings::labelPrinterLabelWidth() const
{
    return value("label_printer_label_width",1).toFloat();
}

void AppSettings::setLabelPrinterLabelWidth(float newLabelPrinterLabelWidth)
{
    if (qFuzzyCompare(labelPrinterLabelWidth(), newLabelPrinterLabelWidth))
        return;
    setValue("label_printer_label_width",newLabelPrinterLabelWidth);
    emit labelPrinterLabelWidthChanged();
}

float AppSettings::labelPrinterLabelHeight() const
{
    return value("label_printer_label_height",1).toFloat();
}

void AppSettings::setLabelPrinterLabelHeight(float newLabelPrinterLabelHeight)
{
    if (qFuzzyCompare(labelPrinterLabelHeight(), newLabelPrinterLabelHeight))
        return;
    setValue("label_printer_label_height",newLabelPrinterLabelHeight);
    emit labelPrinterLabelHeightChanged();
}

int AppSettings::labelPrinterLabelSizeUnit() const
{
    return value("label_printer_label_size_unit",QPageSize::Inch).toInt();
}

void AppSettings::setLabelPrinterLabelSizeUnit(int newLabelPrinterLabelSizeUnit)
{
    if (labelPrinterLabelSizeUnit() == newLabelPrinterLabelSizeUnit)
        return;
    setValue("label_printer_label_size_unit",newLabelPrinterLabelSizeUnit);
    emit labelPrinterLabelSizeUnitChanged();
}

QString AppSettings::about()
{
    QFile file(":/About.md");

    file.open(QIODevice::ReadOnly);
    QString text=file.readAll();

    file.close();
    return text;
}



QUrl AppSettings::serverUrl()
{
    return value("http_server_url").toUrl();
}

void AppSettings::setServerUrl(const QUrl &url)
{
    setValue("http_server_url",url);
    emit serverUrlChanged(url);
}

QStringList AppSettings::servers()
{
    return value("servers").toStringList();
}

void AppSettings::setServers(const QStringList &newServers)
{
    setValue("servers",newServers);
}

QLocale::Language AppSettings::language()
{
    return static_cast<QLocale::Language>(value("app_language",QLocale::English).toUInt());
}

void AppSettings::setLanguage(const QLocale::Language language)
{
    setValue("app_language",language);

}

void AppSettings::setFont(const QString &font)
{
    setValue("app_font",font);
}

QString AppSettings::font()
{
    return value("app_font","Arial").toString();
}


QJsonObject AppSettings::user() const
{
    QJsonDocument doc=QJsonDocument::fromJson(this->value("user").toByteArray());

    return doc.object();
}

void AppSettings::setUser(const QJsonObject &user)
{
    QJsonDocument doc(user);
    setValue("user",doc.toJson(QJsonDocument::Compact));
}

void AppSettings::setServerUrl(const QString &host, const uint port, const bool useSSL)
{
    QUrl url;
    url.setHost(host);
    url.setPort(port);
    url.setScheme(useSSL ? "https" : "http");

    setServerUrl(url);
}
QString AppSettings::hwID()
{

#ifdef Q_OS_ANDROID
    return deviceUuid();
#elif defined(Q_OS_WASM)
    return QStringLiteral("wasm");
#else
    return QSysInfo::machineUniqueId();
#endif
}
