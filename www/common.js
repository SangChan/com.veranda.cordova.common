function Common() {}

Common.prototype.getInfo = function(successCallback, errorCallback) {
	cordova.exec(successCallback, errorCallback, "Common", "getDeviceInfo", []);
}

Common.prototype.setLoginToken = function(successCallback, errorCallback, value) {
    if (value === null || value === undefined) {
		errorCallback ();
		return;
	}
	cordova.exec (successCallback, errorCallback,"Common", "setLoginToken", [value]);
};

Common.prototype.getLoginToken = function(successCallback, errorCallback) {
	_successCallback = function (_value) {
		var value = _value;
		try {
			value = JSON.parse (_value);
		} catch (e) {
		}
		successCallback (value);
	}

	cordova.exec (_successCallback, errorCallback,"Common", "getLoginToken", []);
    
};

Common.prototype.getRegistrationID = function(successCallback, errorCallback) {
  	_successCallback = function (_value) {
		var value = _value;
		try {
			value = JSON.parse (_value);
		} catch (e) {
		}
		successCallback (value);
	}

	cordova.exec (_successCallback, errorCallback,"Common", "getRegistrationID", []);
};

module.exports = new Common();