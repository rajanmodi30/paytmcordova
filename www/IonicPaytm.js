

var IonicPaytm = {




    Add: function (arg0, success, error) {
        cordova.exec(success, error, 'IonicPaytm', 'Add', [arg0]);
    }
    ,
    StartTransaction: function (arg0, success, error) {
        cordova.exec(success, error, 'IonicPaytm', 'StartTransaction', [arg0]);
    }

};

module.exports = IonicPaytm;
