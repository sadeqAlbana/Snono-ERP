#ifndef UTILS_H
#define UTILS_H

#include <QVariant>
#include <qrcodegen.hpp>
namespace Currency
{
    QString formatString(const QVariant &value);
};

namespace QrCode{
std::string toSvgString(const qrcodegen::QrCode &qr, int border);

}


#endif // UTILS_H
