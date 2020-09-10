


/// 页面状态类型
enum ViewState {
  idle,
  busy, //加载中
  empty, //无数据
  error, //加载失败
}

enum ViewStateErrorType{
  defaultError,
  //网络错误
  netWorkTimeOutError,
  //未登录错误
  unauthorizedError
}


class ViewStateError{
  ViewStateErrorType _errorType;
  String message;
  String errorMessage;

  ViewStateError(this._errorType,{ this.message, this.errorMessage}){
    _errorType ??= ViewStateErrorType.defaultError;
    message ??= errorMessage;
  }

  ViewStateErrorType get errorType => _errorType;


  ///加入get方法 方便操作
  get isDefaultError => _errorType == ViewStateErrorType.defaultError;

  get isNetWortTimeOut => _errorType == ViewStateErrorType.netWorkTimeOutError;

  get isUnauthorized => _errorType == ViewStateErrorType.unauthorizedError;

  @override
  String toString() {
    return 'ViewStateError{_errorType: $_errorType, message: $message, errorMessage: $errorMessage}';
  }
}