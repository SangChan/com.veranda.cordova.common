package com.veranda.cordova;

import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.provider.Settings;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

/**
 * Created by sangchan on 15. 2. 24..
 */
public class Common extends CordovaPlugin {
    private final String ACTION_GET__DEVICE_INFO = "getDeviceInfo";
    private final String ACTION_GET_LOGIN_TOKEN = "getLoginToken";
    private final String ACTION_SET_LOGIN_TOKEN = "setLoginToken";
    private final String ACTION_GET_REGISTRATION_ID = "getRegistrationID";

    private final String KEY_REGISTRATION_ID = "registration_id";
    private final String KEY_LOGIN_TOKEN = "login_token";
    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext) throws JSONException {
        if (action.equals(ACTION_GET__DEVICE_INFO)) {
            JSONObject r = new JSONObject();
            r.put("version", this.getOSVersion());
            r.put("platform", this.getPlatform());
            r.put("model", this.getModel());
            r.put("manufacturer", this.getManufacturer());
            r.put("registration_id", this.getValueByKey(KEY_REGISTRATION_ID));
            callbackContext.success(r);
        }
        else if (action.equals(ACTION_GET_LOGIN_TOKEN)) {
            return this.getValueByKey(KEY_LOGIN_TOKEN, callbackContext);
        }
        else if (action.equals(ACTION_SET_LOGIN_TOKEN)) {
            String value  = args.getString(0);
            return this.setValueByKey(KEY_LOGIN_TOKEN, value, callbackContext);

        }
        else if (action.equals(ACTION_GET_REGISTRATION_ID)) {
            return this.getValueByKey(KEY_REGISTRATION_ID, callbackContext);
        }
        return false;
    }

    /**
     * Get the OS name.
     *
     * @return
     */
    public String getPlatform() {
        return "Android";
    }

    public String getModel() {
        String model = android.os.Build.MODEL;
        return model;
    }

    public String getManufacturer() {
        String manufacturer = android.os.Build.MANUFACTURER;
        return manufacturer;
    }
    /**
     * Get the OS version.
     *
     * @return
     */
    public String getOSVersion() {
        String osversion = android.os.Build.VERSION.RELEASE;
        return osversion;
    }

    private boolean setValueByKey(final String key, final String value, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {public void run() {

            SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(cordova.getActivity());
            SharedPreferences.Editor editor = sharedPrefs.edit();

            editor.putString (key, value);

            if (editor.commit()) {
                callbackContext.success();
            } else {
                callbackContext.error("Can't commit change");
            }
        }});

        return true;
    }

    private boolean getValueByKey(final String key, final CallbackContext callbackContext) {
        cordova.getThreadPool().execute(new Runnable() {public void run() {

            SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(cordova.getActivity());
            String returnVal = null;
            if (sharedPrefs.contains(key)) {
                Object obj = sharedPrefs.getAll().get(key);
                returnVal = (String)obj;
                callbackContext.success(returnVal);
            } else {
                callbackContext.error(0);
            }

        }});

        return true;
    }

    private String returnVal;

    private String getValueByKey(final String key) {
        cordova.getThreadPool().execute(new Runnable() {public void run() {
            SharedPreferences sharedPrefs = PreferenceManager.getDefaultSharedPreferences(cordova.getActivity());
            returnVal = null;
            if (sharedPrefs.contains(key)) {
                Object obj = sharedPrefs.getAll().get(key);
                returnVal = (String)obj;
            }


        }});

        return returnVal;
    }
}
