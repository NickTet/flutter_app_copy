
import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:package_info/package_info.dart';

///是否是生产环境

const bool inProduction = const bool.fromEnvironment("dart.vm.product");


class PlatformUtils{
  ///获取包名信息
  static Future<PackageInfo> getAppPackageInfo(){
    return PackageInfo.fromPlatform();
  }

  static Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  static Future<String> getBuildNum() async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  static Future getDeviceInfo() async{
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    if(Platform.isAndroid){
      return  await deviceInfoPlugin.androidInfo;
    }else if(Platform.isIOS){
      return await deviceInfoPlugin.iosInfo;
    }else{
      return null;
    }
  }
}