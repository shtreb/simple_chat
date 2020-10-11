import 'package:chat_models/chat_models.dart';
import 'package:flutter/foundation.dart';

class CheckableUser with ChangeNotifier {
  final User user;
  bool isChecked;

  void set setChecked(bool isChecked) {
    this.isChecked = isChecked;
    notifyListeners();
  }

  CheckableUser({
    this.user,
    this.isChecked = false,
  });
}
