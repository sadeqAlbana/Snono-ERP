#ifndef UTILS_H
#define UTILS_H

#include <QVariant>
#include "qrcodegen.hpp"
#include <QCryptographicHash>
namespace Currency
{
    QString formatString(const QVariant &value);
};

namespace QrCode{
std::string toSvgString(const qrcodegen::QrCode &qr, int border);

}



namespace FileUtils{


 enum OperationStatusCode{
     Success = 0,
     Failure = 1,
     PartialSuccess = 2,
 };

 FileUtils::OperationStatusCode copyDir(QString srcPath, QString dstPath);
 QByteArray fileChecksum(const QString fileName, const QCryptographicHash::Algorithm algorithim);

}

namespace SystemUtils{
QString  executeCommand(QString command,const QStringList args);
void rebootDevice();

}

namespace Json{
bool printJson(const QString &title, const QJsonArray &data, QList<QPair<QString, QString> > headers={});
}

namespace Shein{
QJsonObject extractJsonFromHtml(const QUrl &path);
}


#endif // UTILS_H
