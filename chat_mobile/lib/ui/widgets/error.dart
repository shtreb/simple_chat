import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CustomError extends StatelessWidget {

  final String _title;
  final String _action;
  final VoidCallback _callback;

  CustomError({
    String title,
    String action,
    VoidCallback callback
  }) :
      _title = title ?? '',
      _action = action,
      _callback = callback;

  @override Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(_title, style: Theme.of(context).appBarTheme.textTheme.headline6,),
      CupertinoButton(
          child: Text(_action),
          onPressed: _callback
      )
    ],
  );

}