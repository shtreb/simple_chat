import 'package:chat_mobile/data/cases/services/auth-service.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(Icons.exit_to_app),
        tooltip: 'Logout',
        onPressed: () async {
          await authService.logout();
          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
        });
  }
}
