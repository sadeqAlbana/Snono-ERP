#include "posapplication.h"
#include <QDebug>
#include <QDirIterator>
#include <QFontDatabase>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include "authmanager.h"
#include "posnumpadwidget/utils/numbereditor.h"

#include "receiptgenerator.h"
#include <QTimer>
#include <QJsonDocument>
#include <QJsonObject>
#include "api.h"
#include <QPrinterInfo>
#include <QIcon>
#include "appsettings.h"

#include <networkresponse.h>
#include "appqmlnetworkaccessmanagerfactory.h"
#include <QClipboard>
#include <QDir>
#include <QDirIterator>
#include <QFontDatabase>
#include <QTranslator>
#include <QSortFilterProxyModel>
#include <QTemporaryFile>
#include <QResource>
#include "utils.h"
#include <QStandardPaths>
#include <networkresponse.h>
#include <QUrlQuery>
PosApplication::PosApplication(int &argc, char **argv) : QApplication(argc, argv),
    m_engine(new QQmlApplicationEngine(this))
{
    loadFonts();
    loadTranslators();
    initSettings();
    updateAppLanguage();

    QIcon::setThemeName("CoreUI");
    connect(this,&PosApplication::languageChanged,this,&PosApplication::updateAppLanguage);
    m_engine->setNetworkAccessManagerFactory(new AppQmlNetworkAccessManagerFactory);
    NumberEditor *nb=new NumberEditor(this);
    ReceiptGenerator *gen=new ReceiptGenerator(this);

    m_engine->rootContext()->setContextProperty("App",this);
    m_engine->rootContext()->setContextProperty("Settings",AppSettings::instance()); //this is probably causing a problem

    m_engine->rootContext()->setContextProperty("AuthManager",AuthManager::instance());
    m_engine->rootContext()->setContextProperty("NetworkManager",PosNetworkManager::instance());
    //qmlRegisterSingletonInstance("PosFe",1,0,"NetworkManager",PosNetworkManager::instance());

    m_engine->rootContext()->setContextProperty("NumberEditor",nb);
    m_engine->rootContext()->setContextProperty("ReceiptGenerator",gen);
    m_engine->rootContext()->setContextProperty("Api",Api::instance());
    m_engine->rootContext()->setContextProperty("Clipboard",QApplication::clipboard());

    connect(AuthManager::instance(),&AuthManager::loggedIn,this,[this]{


        Api::instance()->receipt()->subscribe([this](NetworkResponse *res){
            if(res->status()==200){
                QByteArray imageData=QByteArray::fromBase64(res->json("data")["receipt_logo"].toString().toUtf8());
                if(imageData.size()){
                    QDir().mkpath(AppSettings::storagePath()+"/assets");
                    QImage image=QImage::fromData(imageData);
                    image.save(AppSettings::storagePath()+"/assets/"+"receipt_logo.png");
                }

                QJsonObject data=res->json("data").toObject();
                AppSettings::instance()->setReceiptCompanyName(data["receipt_company_name"].toString());
                AppSettings::instance()->setReceiptPhoneNumber(data["receipt_phone"].toString());
                AppSettings::instance()->setReceiptBottomNote(data["receipt_bottom_note"].toString());

            }
        });
    });




    //instances should be added before engine.load
    m_engine->addImportPath(QStringLiteral(":/"));
    m_engine->addImportPath(QStringLiteral(":/qrc"));
    //m_engine->addImportPath(QStringLiteral(":/qrc/qml"));


    //m_engine->addImportPath(QStringLiteral(":/qml"));
    const QUrl url(u"qrc:/PosFe/qml/main.qml"_qs);
    m_engine->load(url);
    if (m_engine->rootObjects().isEmpty())
        this->exit(-1);

    connect(this,&QApplication::aboutToQuit,m_engine,&QObject::deleteLater);
}

PosApplication::~PosApplication()
{

}

QVariantList PosApplication::languages() const
{
    QVariantList list;
    list << QVariantMap{{"key","American English"},{"value",QLocale::English}};
    for(const QTranslator *translator : m_translators){
        QLocale locale(translator->language());
        list << QVariantMap{{"key",locale.nativeLanguageName()},{"value",locale.language()}};
    }
    return list;
}

QList<QLocale> PosApplication::locales() const
{
    QList<QLocale>  list;
    list << QLocale(QLocale::English);
    for(const QTranslator *translator : m_translators){
        list << QLocale(translator->language());

    }
    return list;
}

void PosApplication::initSettings()
{
    // qDebug()<<"init settings";
}

void PosApplication::loadFonts()
{
    //first load font files
    QDirIterator it(":/fonts", QStringList{{"*.ttf"}}, QDir::Files, QDirIterator::Subdirectories);
    while (it.hasNext()){
        QString next= it.next();
        QFontDatabase::addApplicationFont(next);
    }
}

void PosApplication::loadTranslators()
{
    QDirIterator it(":/i18n", QStringList{{"*.qm"}}, QDir::Files);
    while (it.hasNext()){
        QString next= it.next();
        QTranslator *translator= new QTranslator(this);
        if(translator->load(next)){
            m_translators << translator;
        }
    }
}

QLocale::Language PosApplication::language() const
{
    return AppSettings::instance()->language();
}

void PosApplication::setLanguage(const QLocale::Language newLanguage)
{
    if (language() == newLanguage)
        return;
    AppSettings::instance()->setLanguage(newLanguage);
    emit languageChanged();
}

void PosApplication::updateAppLanguage()
{
    QTranslator *translator=nullptr;
    for(QTranslator *item : m_translators){
        if(QLocale(item->language()).language()==language()){
            translator=item;
        }
    }
    if(translator){
        QCoreApplication::installTranslator(translator);
        if(language()==QLocale::Arabic){
            AppSettings::instance()->setFont("Hacen Liner Screen");
            this->updateAppFont();
        }
    }
    else if
            (language()==QLocale::English){
        for(QTranslator *item : m_translators){
            QCoreApplication::removeTranslator(item);
        }
    }

    m_engine->setUiLanguage(QLocale(language()).name());
    m_engine->retranslate();
    setLayoutDirection(QLocale(language()).textDirection());
}

void PosApplication::updateAppFont()
{
    QFont font=this->font();
    font.setFamily(AppSettings::instance()->font());
    this->setFont(font);
}

QStringList PosApplication::availablePrinters()
{
#ifndef Q_OS_IOS

    QStringList printers = QPrinterInfo::availablePrinterNames();
    printers.prepend("Default Printer");
    return printers;
#else
return QStringList();
#endif
}

void PosApplication::downloadVersion(const int version)
{
#ifndef Q_OS_WASM
    QUrlQuery query;

    QString platform=AppSettings::platform();
    query.addQueryItem("software","pos-fe");
    query.addQueryItem("platform",platform);
    query.addQueryItem("version",QString::number(version));
    QUrl url("https://software.sadeq.shop/download");
    url.setQuery(query);
    QNetworkRequest request = PosNetworkManager::instance()->createNetworkRequest(url);


    request.setTransferTimeout(60*60*1000); // 1 hour

    PosNetworkManager::instance()->get(request)
            ->subscribe([this](NetworkResponse *res){
        if(res->error()!=QNetworkReply::NoError){
            qWarning()<<QString("Warning: could not download update due to network error %1").arg(res->errorString());
            emit downloadVersionReply(false);
            return;
        }
        QByteArray data=res->binaryData();
        QTemporaryFile resource;
        if (!resource.open()){
            qWarning()<<"Warning: could not create temprary update file";
            emit downloadVersionReply(false);
            return;

        }
        resource.write(data);
        resource.close();

        bool registered=QResource::registerResource(resource.fileName());
        if(!registered){
            qWarning()<<"Warning: could not register update resource file";
            emit downloadVersionReply(false);
            return;
        }

        QString binaryPath=QCoreApplication::applicationFilePath(); //includes name
        QString binaryName=QFileInfo(binaryPath).fileName();
        QString tmp = QStandardPaths::standardLocations(QStandardPaths::TempLocation).value(0);

        qDebug()<<"binary name: " << binaryName;
        QFile checksum(":/update/files/sha256sums.txt");
        qDebug()<<"Checksum file exists : " << checksum.exists();
        checksum.open(QIODevice::ReadOnly | QFile::Text);
        QTextStream in(&checksum);
        while(!in.atEnd()){
            QString line=in.readLine();
            QStringList pair=line.split("  ");
            QString sha256=pair.value(0);
            QString fileName=pair.value(1);
            qDebug()<<"pair: " << pair;

            QString fileChecksum=FileUtils::fileChecksum(QString(":/update/files/%1").arg(fileName),QCryptographicHash::Sha256);
            if(fileChecksum!=sha256){
                qWarning()<<QString("Warning: Invalid checksum for update file %1").arg(fileName);
                qWarning()<<"expected checksum: " << sha256;
                qWarning()<<"actual checksum: " << fileChecksum;
                checksum.close();
                return;
            }
        }

        checksum.close();

        QDir installData(":/update/files/install_data");
        if(installData.exists()){
            FileUtils::copyDir(":/update/files/install_data",tmp);
#if  defined(Q_OS_LINUX) || defined(Q_OS_MAC)
            QString scriptPath=tmp+"/install_data/install.sh";
#elif defined Q_OS_WINDOWS
            QString scriptPath=tmp+"/install_data/install.bat";
#endif
            if(QFile(scriptPath).exists()){
                QFile(scriptPath).setPermissions(QFileDevice::ExeOther);
#if  defined(Q_OS_LINUX) || defined(Q_OS_MAC)
                qDebug()<<"script exec: " << SystemUtils::executeCommand("/bin/bash",QStringList{"-c", scriptPath});
#elif defined Q_OS_WINDOWS
                qDebug()<<"script exec: " << SystemUtils::executeCommand("cmd.exe",QStringList{"/C",scriptPath});
#endif
            }
        }

        qDebug()<<"binary path: " << binaryPath;

        bool renamed=QFile::rename(binaryPath,tmp+"/"+binaryName+".old");
        if(!renamed){
            qWarning()<<"Warning: could not move original binary file";
            return;
        }
        bool success=QFile::copy(QString(":/update/files/%1").arg(binaryName),binaryPath);
        qDebug()<<"setting permission: "<<QFile(binaryPath).setPermissions(QFileDevice::ExeOther);

        qDebug()<<"update success: " << success;
        //SystemUtils::rebootDevice();
        qApp->quit();
    });
#endif
}

int PosApplication::version()
{
    return APP_VERSION;
}

void PosApplication::setMouseBusy(const bool busy)
{
    if(busy){
        setOverrideCursor(Qt::WaitCursor);
    }else{
        restoreOverrideCursor();
    }
}
