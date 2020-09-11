
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutterappcopy/provider/view_state_list_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

abstract class ViewStateRefreshListModel<T> extends ViewStateListModel<T>{
  ///当前第一页代码
  static const int pageNumFirst = 0;

  ///分页条目数量

  static const int pageSize = 20;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  RefreshController get refreshController => _refreshController;

  int _currentPageNum  = pageNumFirst;

  /// 下拉刷新
  ///
  /// [init] 是否是第一次加载
  /// true:  Error时,需要跳转页面
  /// false: Error时,不需要跳转页面,直接给出提示
  Future<List<T>> refresh({bool init = false}) async{
    try{
      _currentPageNum = pageNumFirst;
      var data = await loadData(pageNum: pageNumFirst);
      if(data.isEmpty){
        _refreshController.refreshCompleted(resetFooterState: true);
        list.clear();
        setEmpty();
      }else{
        onCompleted(data);
        list.clear();
        list.addAll(data);
        _refreshController.refreshCompleted();
        if(data.length<pageSize){
          _refreshController.loadNoData();
        }else{
          refreshController.loadComplete();
        }
        setIdle();
      }
      return data;
    }catch(e,s){
      /// 页面已经加载了数据,如果刷新报错,不应该直接跳转错误页面
      /// 而是显示之前的页面数据.给出错误提示
      if (init) list.clear();
      refreshController.refreshFailed();
      setError(e, s);
      return null;
    }
  }

  Future<List<T>> loadMore() async{
    try{
      var data = await loadData(pageNum: ++_currentPageNum);
      if(data.isEmpty){
        _currentPageNum--;
        refreshController.loadNoData();
      }else{
        onCompleted(data);
        list.addAll(data);
        if(data.length<pageSize){
          refreshController.loadNoData();
        }else{
          refreshController.loadFailed();
        }
        notifyListeners();
      }
      return data;
    }catch(e,s){
      _currentPageNum--;
      refreshController.refreshFailed();
      debugPrint('error--->\n' + e.toString());
      debugPrint('statck--->\n' + s.toString());
      setError(e, s);
    }
  }


  Future<List<T>> loadData({int pageNum});


  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }
}