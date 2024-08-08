#include "sheinordermanifestmodel.h"

// SheinOrderManifestModel::SheinOrderManifestModel(QObject *parent)
//     : JsonModel{parent}
// {}


SheinOrderManifestModel::SheinOrderManifestModel(QObject *parent) :
    JsonModel (QJsonArray(),{
                                  {"thumb",tr("Image"),QString(),true,"image"},
                             {"name",tr("Name")} ,
                             {"qty",tr("Qty")} ,
                             {"size",tr("Size")} ,
                               },
              parent)
{}
