package com.lostium.cordova.share;

import java.util.ArrayList;
import java.util.List;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONObject;
import org.json.JSONException;

import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.os.Parcelable;
import android.text.Html;

public class SocialShare extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callback) {
        try {
            if (action.equals("showSMSComposer")) {
                String smsBody = args.getString(0);
                Intent sendIntent = new Intent(Intent.ACTION_VIEW);
                sendIntent.putExtra("sms_body", smsBody);
                sendIntent.setType("vnd.android-dir/mms-sms");
                this.cordova.startActivityForResult(this, sendIntent, 0);
            } else if (action.equals("showEmailComposer")) {
                List<Intent> targetedShareIntents = new ArrayList<Intent>();
                Intent share = new Intent(android.content.Intent.ACTION_SEND);
                share.setType("text/html");
                List<ResolveInfo> resInfo = this.cordova.getActivity().getPackageManager().queryIntentActivities(share, 0);
                if (!resInfo.isEmpty()) {

                	String nameApp = "mail";
                    for (ResolveInfo info : resInfo) {
                        Intent targetedShare = new Intent(android.content.Intent.ACTION_SEND);
                        targetedShare.setType("text/html"); // put here your mime type

                        if (info.activityInfo.packageName.toLowerCase().contains(nameApp)
                                || info.activityInfo.name.toLowerCase().contains(nameApp)) {

                        	targetedShare.putExtra(Intent.EXTRA_EMAIL, "");
                        	targetedShare.putExtra(Intent.EXTRA_SUBJECT, args.getString(0));
                            targetedShare.putExtra(Intent.EXTRA_TEXT, Html.fromHtml(args.getString(1)));
                            targetedShare.setPackage(info.activityInfo.packageName);
                            targetedShareIntents.add(targetedShare);
                        }
                    }

                    Intent chooserIntent = Intent.createChooser(targetedShareIntents.remove(0), "Select app to share");
                    chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, targetedShareIntents.toArray(new Parcelable[]{}));
                    this.cordova.startActivityForResult(this, chooserIntent, 0);
                }
            } else if (action.equals("showTwitter")) {
                List<Intent> targetedShareIntents = new ArrayList<Intent>();
                Intent share = new Intent(android.content.Intent.ACTION_SEND);
                share.setType("text/plain");
                List<ResolveInfo> resInfo = this.cordova.getActivity().getPackageManager().queryIntentActivities(share, 0);
                if (!resInfo.isEmpty()) {

                	String nameApp = "twitter";
                    for (ResolveInfo info : resInfo) {
                        Intent targetedShare = new Intent(android.content.Intent.ACTION_SEND);
                        targetedShare.setType("text/plain"); // put here your mime type

                        if (info.activityInfo.packageName.toLowerCase().contains(nameApp)
                                || info.activityInfo.name.toLowerCase().contains(nameApp)) {

                        	targetedShare.putExtra(Intent.EXTRA_TEXT, args.getString(0).concat(args.length()>1?" ".concat(args.getString(1)):""));
                            targetedShare.setPackage(info.activityInfo.packageName);
                            targetedShareIntents.add(targetedShare);
                        }
                    }

                    Intent chooserIntent = Intent.createChooser(targetedShareIntents.remove(0), "Select app to share");
                    chooserIntent.putExtra(Intent.EXTRA_INITIAL_INTENTS, targetedShareIntents.toArray(new Parcelable[]{}));
                    this.cordova.startActivityForResult(this, chooserIntent, 0);
                }
            }
                callback.success();
                return true;
            }catch (Exception ex) {
            callback.error("no funcionó");
            return false;
        }
        }
    }
