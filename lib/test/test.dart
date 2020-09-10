

import 'package:flutter/cupertino.dart';

class AppState{
  bool isLoading;

  AppState({this.isLoading});
  
  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading}';
  }
}


class _InheritedStateContainer extends InheritedWidget{
  AppState data;


  _InheritedStateContainer({Key key, @required this.data,@required Widget child}):super(key:key,child:child);

  @override
  bool updateShouldNotify(_InheritedStateContainer oldWidget) {
    // TODO: implement updateShouldNotify
    return data == oldWidget.data;
  }

}


class AppStateContainer extends StatefulWidget {
  final AppState appState;

  final Widget child;


  AppStateContainer({this.appState, this.child});

  static AppState of(BuildContext context){
    return (context.dependOnInheritedWidgetOfExactType(aspect: _InheritedStateContainer) as _InheritedStateContainer).data;
  }

  @override
  _AppStateContainerState createState() => _AppStateContainerState();
}

class _AppStateContainerState extends State<AppStateContainer> {
  @override
  Widget build(BuildContext context) {
    return _InheritedStateContainer(
        child: widget.child,
        data: widget.appState,
    );
  }
}
