.pragma library



function formatNumber(num) {
  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}

function createObject(path,container,options){
    options = options || false;
    var component = Qt.createComponent(path);
    var obj;
    if (options)
        obj=component.createObject(container,options);
    else
        obj=component.createObject(container);
    return obj;
}