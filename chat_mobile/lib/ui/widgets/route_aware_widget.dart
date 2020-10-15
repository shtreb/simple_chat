import 'package:chat_mobile/flavors/globals.dart';
import 'package:flutter/material.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RouteAwareWidget extends StatefulWidget {
  final String name;
  final Widget child;
  final BuildContext context;

  RouteAwareWidget(this.name, {@required this.child, @required this.context});

  @override State<RouteAwareWidget> createState() => RouteAwareWidgetState();
}

class RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {

  @override void initState() {
    super.initState();
  }
  
  @override void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override void didPush() {
    buildContextsList.add(widget.context);
    debugPrint('didPush ${widget.context.widget.toString()}');
  }

  @override void didPopNext() {
    buildContextsList.removeLast();
    buildContextsList.add(widget.context);
    debugPrint('didPop ${widget.context.widget.toString()}');
  }

  @override Widget build(BuildContext context) => widget.child;
}