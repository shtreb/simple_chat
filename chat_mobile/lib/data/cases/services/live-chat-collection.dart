import 'package:flutter/foundation.dart';
import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/cases/services/live-collection.dart';

class LiveChatCollection extends LiveCollection<Chat> {

  double currentScrollOffset = .0;

  @override Future<List<Chat>> load() async {
    List<Chat> list = await ChatsClient(MobileApiClient()).read({});
    return list;
  }

}