import 'package:chat_mobile/generated/i18n.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Center(
        child: Text(S.of(context).app_name,
          style: TextStyle(
            color: Colors.white,
            decoration: TextDecoration.none
          ),
        )
      ),
    );
  }
}