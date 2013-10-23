package com.lostium.cordova.share;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

public class SocialShare extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callback) {
        try {
            JSONObject r = new JSONObject();
            r.put("bundleId", this.cordova.getActivity().getApplicationContext().getPackageName());
            callback.success(r);
            return true;
        } catch (JSONException ex) {
            return false;
        }
    }
}
