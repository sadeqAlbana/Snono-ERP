.pragma library

const units = ['bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];

function formatNumber(num) {
    if(num===null){
        return ""
    }

  return num.toString().replace(/(\d)(?=(\d{3})+(?!\d))/g, '$1,')
}

function formatCurrency(num) {
  return formatNumber(num) + " IQD"
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

function firstDayOfMonth(){
    var date = new Date();
    return new Date(date.getFullYear(), date.getMonth(), 1);
}

function lastDayOfMonth(){
    var date = new Date();
    return new Date(date.getFullYear(), date.getMonth() + 1, 0);
}


function niceBytes(x){

  let l = 0, n = parseInt(x, 10) || 0;

  while(n >= 1024 && ++l){
      n = n/1024;
  }

  return(n.toFixed(n < 10 && l > 0 ? 1 : 0) + ' ' + units[l]);
}

