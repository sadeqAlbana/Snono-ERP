#include "utils.h"

#include <QLocale>
#include <ostream>
#include <iostream>
#include <sstream>
#include <QDir>
#include <QProcess>
#include <QXmlStreamWriter>
#include <QXmlAttributes>
QString Currency::formatString(const QVariant &value)
{
    QString text;
    if(value.userType()==QMetaType::Float || value.userType()==QVariant::Double || value.userType()==QVariant::Int)
    {
        QLocale locale(QLocale::Arabic,QLocale::ArabicScript,QLocale::Iraq);

        text= QLocale(QLocale::English,QLocale::ArabicScript,QLocale::Iraq).toCurrencyString(value.toReal(),locale.currencySymbol(QLocale::CurrencySymbol),0);
        //text= QLocale(QLocale::Arabic,QLocale::Script::ArabicScript,QLocale::Iraq).toCurrencyString(value.toDouble());

        return text;
    }
    return QString();
}

std::string QrCode::toSvgString(const qrcodegen::QrCode &qr, int border) {
    if (border < 0)
        throw std::domain_error("Border must be non-negative");
    if (border > INT_MAX / 2 || border * 2 > INT_MAX - qr.getSize())
        throw std::overflow_error("Border too large");

    std::ostringstream sb;
    sb << "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    sb << "<!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\">\n";
    sb << "<svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 ";
    sb << (qr.getSize() + border * 2) << " " << (qr.getSize() + border * 2) << "\" stroke=\"none\">\n";
    sb << "\t<rect width=\"100%\" height=\"100%\" fill=\"#FFFFFF\"/>\n";
    sb << "\t<path d=\"";
    for (int y = 0; y < qr.getSize(); y++) {
        for (int x = 0; x < qr.getSize(); x++) {
            if (qr.getModule(x, y)) {
                if (x != 0 || y != 0)
                    sb << " ";
                sb << "M" << (x + border) << "," << (y + border) << "h1v1h-1z";
            }
        }
    }
    sb << "\" fill=\"#000000\"/>\n";
    sb << "</svg>\n";
    return sb.str();
}

FileUtils::OperationStatusCode FileUtils::copyDir(QString srcPath, QString dstPath)
{

    QDir src(srcPath);
    if(!QDir().mkpath(dstPath+"/"+src.dirName())){
        return FileUtils::OperationStatusCode::Failure;
    }
    dstPath+="/"+src.dirName();
    int successCount=0;

    for(const QFileInfo &fileInfo : src.entryInfoList(QDir::AllEntries | QDir::NoDotAndDotDot)){
        if(fileInfo.isDir()){
            src.mkpath(dstPath+'/'+fileInfo.fileName());

            FileUtils::OperationStatusCode sc=copyDir(dstPath+'/'+fileInfo.fileName(),fileInfo.absoluteFilePath());
            if(sc!=FileUtils::OperationStatusCode::Success){
                return successCount<=0? sc : OperationStatusCode::PartialSuccess;
            }
        }
        if(QFile::copy(fileInfo.absoluteFilePath(), dstPath+'/'+fileInfo.fileName())){
            successCount++;
        }
    }

    if(successCount<=0)
        return FileUtils::OperationStatusCode::Failure;
    if(successCount!=src.count())
        return FileUtils::OperationStatusCode::PartialSuccess;
    return FileUtils::OperationStatusCode::Success;
}

QByteArray FileUtils::fileChecksum(const QString fileName, const QCryptographicHash::Algorithm algorithim)
{
    QFile f(fileName);
    if (f.open(QFile::ReadOnly)) {
        QCryptographicHash hash(algorithim);
        if (hash.addData(&f)) {
            f.close();
            return hash.result().toHex();
        }
    }
    return QByteArray();
}

QString SystemUtils::executeCommand(QString command, const QStringList args)
{
#if !defined(Q_OS_IOS) && !defined(Q_OS_WASM)
    QProcess process;
    if(!args.isEmpty())
        process.start(command,args);
    process.waitForFinished(-1);
    QString result=process.readAllStandardOutput();
    return result;
#else

return QString();

#endif
}

void SystemUtils::rebootDevice()
{

#ifdef Q_OS_LINUX
//    sync();
//    reboot(RB_AUTOBOOT);
#endif

}

bool SystemUtils::printJson(const QMap<QString, QString> headers, const QJsonArray &data)
{

        QString text;
        QXmlStreamWriter stream(&text);
        QDateTime dt=QDateTime::currentDateTime();
//        QStringList headers{"Item","Stock","Item","Stock","Item","Stock","Item","Stock","Item","Stock"};
        stream.setAutoFormatting(true);
        stream.writeStartDocument();
        stream.writeStartElement("html");

        stream.writeTextElement("style","table, th,td,tr,h2 {border:1px solid black; text-align: center; width:100%; border-collapse: collapse;}");

        stream.writeTextElement("h2",QString("Stock Report for %1").arg(dt.toString()));


        stream.writeStartElement("table");
        stream.writeAttribute("style", "width:100%;");
        stream.writeStartElement("tr");
        for(auto header: headers){
            stream.writeTextElement("th",header);
        }
        stream.writeEndElement();//tr

        for(int i=0; i<data.size(); i+=5){
            stream.writeStartElement("tr");
            if(i%2==0)
                stream.writeAttribute("style","background-color:#F0F0F0;");

            for(int j=i; j<i+5; j++){
                QJsonObject record=this->recordAt(j);
                stream.writeTextElement("td",record["name"].toString());
                stream.writeTextElement("td",QString::number(record["stock"].toDouble()));
            }



            stream.writeEndElement();//tr
        }



        stream.writeEndElement(); //table
        stream.writeEndElement(); //html
        stream.writeEndDocument();

        QTextDocument doc;
        doc.setHtml(text);

#ifndef Q_OS_IOS
        QPrinter printer(QPrinterInfo::defaultPrinter());
        printer.setPageSize(QPageSize::A4);
        doc.print(&printer);

        printCSV();
#endif


}
