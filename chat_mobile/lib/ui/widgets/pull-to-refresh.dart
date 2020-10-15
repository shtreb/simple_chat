import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PullToRefresh extends StatelessWidget {

  final RefreshController _refreshCtrl;
  final String _positive;
  final String _negative;
  final Widget _child;
  final VoidCallback _onRefresh;

  PullToRefresh({
    @required RefreshController refreshController,
    String positive,
    String negative,
    @required Widget child,
    VoidCallback onRefresh
  }) :
      _refreshCtrl = refreshController ?? RefreshController(),
      _positive = positive ?? '',
      _negative = negative ?? '',
      _child = child ?? SizedBox.shrink(),
      _onRefresh = onRefresh;

  @override Widget build(BuildContext context) => SmartRefresher(
      enablePullUp: false,
      enablePullDown: true,
      controller: _refreshCtrl,
      header: WaterDropHeader(
        waterDropColor: Theme.of(context).primaryColor,
        failed: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.close,
              color: Colors.red,
            ),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Text(_negative, style: Theme.of(context).textTheme.bodyText1)
          ],
        ),
        complete: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.done,
              color: Colors.green,
            ),
            const Padding(padding: EdgeInsets.only(left: 15)),
            Text(_positive, style: Theme.of(context).textTheme.bodyText1,
            )
          ],
        ),
      ),
      child: _child,
      onRefresh: _onRefresh,
  );

}