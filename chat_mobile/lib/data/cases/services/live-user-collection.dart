import 'package:flutter/foundation.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/cases/services/live-collection.dart';
import 'package:chat_mobile/flavors/globals.dart';

class LiveUserCollection extends LiveCollection<User> {

  double currentScrollOffset = .0;

  @override
  @protected
  Future<List<User>> load() async {
    UsersClient _usersClient = UsersClient(MobileApiClient());
    List<User> found = await _usersClient.read({});
    found.removeWhere((user) => user.id == currentUser.id);
    return found;
  }

}