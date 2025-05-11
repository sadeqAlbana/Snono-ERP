#include "paymentmethodmodel.h"


PaymentMethodModel::PaymentMethodModel(QObject *parent) : AppNetworkedJsonModel("/paymentMethods",{
                                                      {"id",tr("ID")} ,
                                                      {"name",tr("Name")} ,
                                                      {"type",tr("Type")} ,
                                                      {"account_id",tr("Account ID")} ,
                                                      {"enabled",tr("Enabled")} ,
                                                      {"created_at",tr("Created At")}},parent)
{

}
