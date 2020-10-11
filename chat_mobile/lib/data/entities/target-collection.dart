import 'package:flutter/foundation.dart';
import 'package:chat_models/chat_models.dart';

class TargetCollection with ChangeNotifier {
  List<User> _targetUserList = [];

  List<User> get listTarget => _targetUserList;

  void addTarget(User user) {
    if(_targetUserList.isNotEmpty)
      for(User _user in _targetUserList)
        if(_user.id == user.id) {
          removeTarget(user);
          return;
        }

    _targetUserList.add(user);
    notifyListeners();
  }

  void removeTarget(User user) {
    if(_targetUserList.isEmpty) return;

    for(User _user in _targetUserList)
      if(_user.id == user.id) {
        _targetUserList.remove(_user);
        notifyListeners();
        return;
      }
  }

  bool hasTarget(User user) {
    for(User _user in _targetUserList)
      if(_user.id == user.id) return true;
    return false;
  }
}