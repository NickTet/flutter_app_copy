


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderSelectorWidget<T extends ChangeNotifier,S> extends StatefulWidget {
  final ValueWidgetBuilder builder;
  final S Function(BuildContext,T) selector;
  final T model;
  final Widget child;
  final Function(T model) onModelReady;
  final bool autoDispose;


  ProviderSelectorWidget({Key key,@required this.builder, @required this.selector, this.model, this.child,
    this.onModelReady, this.autoDispose}):super(key:key);

  @override
  _ProviderSelectorWidgetState createState() => _ProviderSelectorWidgetState();
}

class _ProviderSelectorWidgetState<T extends ChangeNotifier> extends State<ProviderSelectorWidget<T,String>> {

  T model;

  @override
  void initState() {
    model = widget.model;
    widget.onModelReady?.call(model);
    super.initState();
  }

  @override
  void dispose() {
    if (widget.autoDispose) model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>.value(
      value: model,
      child: Selector<T,String>(
        selector: (_,s)=>"s",
        builder: widget.builder,
        child: widget.child,
      ),
    );
  }
}
