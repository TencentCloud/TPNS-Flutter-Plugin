package com.tencent.tpns.plugin;

import android.util.Log;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build;
import android.telephony.TelephonyManager;
import android.text.TextUtils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.UUID;

/**
 * 获取系统设备信息的工具类
 */
public class DeviceInfoUtil {

    /* 获取手机唯一序列号 */
    public static String getDeviceId(Context context) {
        TelephonyManager tm =
                (TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE);
        String deviceId = tm.getDeviceId();// 手机设备ID，这个ID会被用为用户访问统计
        if (deviceId == null) {
            deviceId = UUID.randomUUID().toString().replaceAll("-", "");
        }
        return deviceId;
    }

    /* 获取操作系统版本号 */
    public static String getOsVersion() {
        return Build.VERSION.RELEASE;
    }

    /* 获取手机型号 */
    public static String getModel() {
        return Build.MODEL;
    }

    /* 获取手机厂商 */
    public static String getManufacturers() {
        return Build.MANUFACTURER;
    }

    /* 获取app的版本信息 */
    public static int getVersionCode(Context context) {
        PackageManager manager = context.getPackageManager();
        try {
            PackageInfo packageInfo = manager.getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionCode;// 系统版本号
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static String getVersionName(Context context) {
        PackageManager manager = context.getPackageManager();
        try {
            PackageInfo packageInfo = manager.getPackageInfo(context.getPackageName(), 0);
            return packageInfo.versionName;// 系统版本名
        } catch (NameNotFoundException e) {
            e.printStackTrace();
        }
        return "";
    }

    /**
     * getSystemProperty
     *
     * @param propName property name
     * @return result
     */
    public static String getSystemProperty(String propName) {
        String line;
        BufferedReader input = null;
        try {
            Process p = Runtime.getRuntime().exec("getprop " + propName);
            input = new BufferedReader(new InputStreamReader(p.getInputStream()), 1024);
            line = input.readLine();
            input.close();
        } catch (IOException ex) {
            return null;
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    Log.d("DeviceInfoUtil", "close bufferedReader error " + e.toString());
                }
            }
        }
        return line;
    }

    /**
     * 判断 google miui emui meizu oppo vivo 360 Rom
     *
     * @return result
     */

    public static boolean isFcmRom() {
      String property = getSystemProperty("ro.product.vendor.manufacturer");
      return !TextUtils.isEmpty(property) && property.toLowerCase().contains("google");
    }

    public static boolean isMiuiRom() {
        String property = getSystemProperty("ro.miui.ui.version.name");
        return !TextUtils.isEmpty(property);
    }

    public static boolean isEmuiRom() {
        String property = getSystemProperty("ro.build.version.emui");
        return !TextUtils.isEmpty(property);
    }

    public static boolean isMeizuRom() {
        String property = getSystemProperty("ro.build.display.id");
        return property != null && property.toLowerCase().contains("flyme");
    }

    public static boolean isOppoRom() {
        String property = getSystemProperty("ro.build.version.opporom");
        return !TextUtils.isEmpty(property);
    }

    public static boolean isVivoRom() {
        String property = getSystemProperty("ro.vivo.os.version");
        return !TextUtils.isEmpty(property);
    }

    public static boolean is360Rom() {
        return Build.MANUFACTURER != null
                && (Build.MANUFACTURER.toLowerCase().contains("qiku")
                || Build.MANUFACTURER.contains("360"));
    }
}
