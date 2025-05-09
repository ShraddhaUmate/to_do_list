

import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static late SharedPreferences prefs;

  static Future<SharedPreferences> getInstance() async {
    return await SharedPreferences.getInstance();
  }

  /*set deviceId value in SharedPreferences*/
  static Future<String> getDeviceId() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("deviceId") ?? "123";
  }

  /*get deviceId value form SharedPreferences*/
  static setDeviceId(String deviceId) async {
    SharedPreferences   prefs = await SharedPreferences.getInstance();
    print("deviceId   $deviceId");
    prefs.setString("deviceId", deviceId);
  }

  /*set getDeviceType value in SharedPreferences*/
  static Future<String> getDeviceType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id= Platform.isAndroid?"2":"1";
    return prefs.getString("deviceType") ?? id;
  }

/*get setDeviceType value form SharedPreferences*/
  static setDeviceType(String deviceType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("deviceType", deviceType);
  }

  /*set getAppVersion value in SharedPreferences*/
  static Future<String> getAppVersion() async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    return prefs.getString("appVersion") ?? "1.0.0";
  }

/*get setUserEmail value form SharedPreferences*/
  static setAppVersion(String appVersion) async {
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    print("appVersion   $appVersion");
    prefs.setString("appVersion", appVersion);
  }

}