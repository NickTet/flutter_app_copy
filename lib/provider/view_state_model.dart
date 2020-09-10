import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterappcopy/config/net/api.dart';
import 'package:flutterappcopy/provider/view_state.dart';
import 'package:oktoast/oktoast.dart';

class ViewStateModel<T> with ChangeNotifier {
  ///防止页面销毁后，异步任务才完成，导致报错
  bool _disposed = false;

  ///当前页面状态
  ViewState _viewState;

  /// ViewStateError
  ViewStateError _viewStateError;

  ViewStateError get viewStateError => _viewStateError;

  /// 以下变量是为了代码书写方便,加入的get方法.严格意义上讲,并不严谨
  ///
  /// get
  bool get isBusy => viewState == ViewState.busy;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  ViewStateModel({ViewState viewState})
      : _viewState = viewState ?? ViewState.idle {
    debugPrint('ViewStateModel---constructor--->$runtimeType');
  }

  ViewState get viewState => _viewState;

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
    notifyListeners();
  }

  /// set
  void setIdle() {
    viewState = ViewState.idle;
  }

  void setBusy() {
    viewState = ViewState.busy;
  }

  void setEmpty() {
    viewState = ViewState.empty;
  }

  void setError(e, stackTrace, {String message}) {
    ViewStateErrorType errorType = ViewStateErrorType.defaultError;
    if (e is DioError) {
      if (e.type == DioErrorType.CONNECT_TIMEOUT ||
          e.type == DioErrorType.SEND_TIMEOUT ||
          e.type == DioErrorType.RECEIVE_TIMEOUT) {
        errorType = ViewStateErrorType.netWorkTimeOutError;
        message = e.error;
      }else if(e.type == DioErrorType.RESPONSE){
        message = e.error;
      }else if(e.type == DioErrorType.CANCEL){
        message = e.error;
      }else{
        // dio将原error重新套了一层
        e = e.error;
        if (e is UnAuthorizedException) {
          stackTrace = null;
          errorType = ViewStateErrorType.unauthorizedError;
        } else if (e is NotSuccessException) {
          stackTrace = null;
          message = e.message;
        } else if (e is SocketException) {
          errorType = ViewStateErrorType.netWorkTimeOutError;
          message = e.message;
        } else {
          message = e.message;
        }
      }
    }
    _viewState = ViewState.error;
    _viewStateError = ViewStateError(
      errorType,
      message: message,
      errorMessage: e.toString()
    );
    printErrorStack(e, stackTrace);
    onError(viewStateError);
  }

  void onError(ViewStateError viewStateError) {}



  /// 显示错误消息
  showErrorMessage(context, {String message}) {
    if (viewStateError != null || message != null) {
      if (viewStateError.isNetWortTimeOut) {
        message ??= "网络超时";
      } else {
        message ??= viewStateError.message;
      }
      scheduleMicrotask((){
        showToast(message, context: context);
      });
    }
  }

  @override
  String toString() {
    return 'ViewStateModel{_disposed: $_disposed, _viewState: $_viewState, _viewStateError: $_viewStateError}';
  }


  @override
  void notifyListeners() {
    if(!_disposed){
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _disposed = true;
    debugPrint('view_state_model dispose -->$runtimeType');
    super.dispose();
  }
}




/// [e]为错误类型 :可能为 Error , Exception ,String
/// [s]为堆栈信息
printErrorStack(e, s) {
  debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
  if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
}
