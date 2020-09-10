


import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterappcopy/utils/platform_utils.dart';


//compute 必须是顶层函数
_parseAndDecode(String response){
  return jsonDecode(response);
}

//相当于新建一个线程
parseJson(String text){
  return compute(_parseAndDecode,text);
}


abstract class BaseHttp extends DioForNative{


  BaseHttp(){
   ///初始化  加入app通用处理
    (transformer as DefaultTransformer).jsonDecodeCallback = parseJson;
    interceptors..add(HeaderInterceptor());
    init();
  }

  void init();
}

class HeaderInterceptor extends InterceptorsWrapper{

  @override
  Future onRequest(RequestOptions options) async{
    options.connectTimeout = 1000*45;
    options.receiveTimeout = 1000*45;

    var appVersion = await PlatformUtils.getAppVersion();
    var version = Map()
    ..addAll({
      "appVersion":appVersion,
    });
    options.headers['version'] = version;
    options.headers['platform'] = Platform.operatingSystem;
    return super.onRequest(options);
  }
}


abstract class BaseResponseData{
  int code = 0;
  String message;
  dynamic data;

  bool get success;

  BaseResponseData({this.code, this.message, this.data});

  @override
  String toString() {
    return 'BaseResponseData{code: $code, message: $message, data: $data}';
  }
}


class NotSuccessException implements Exception{
  String message;

  NotSuccessException.fromRespData(BaseResponseData data){
    message = data.message;
  }

  @override
  String toString() {
    return 'NotSuccessException{message: $message}';
  }
}


class UnAuthorizedException implements Exception{
  const UnAuthorizedException();

  @override
  String toString() {
    return 'UnAuthorizedException{}';
  }
}