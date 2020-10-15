library chat_mobile.globals;

import 'package:chat_mobile/data/cases/services/live-chat-collection.dart';
import 'package:chat_mobile/data/cases/services/live-user-collection.dart';
import 'package:chat_mobile/data/entities/target-collection.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/widgets.dart';

const String host = 'localhost';
const String webSocketAddress = 'ws://$host:3333/ws';
const String chatApiAddress = 'http://$host:3333';

User currentUser;
LiveUserCollection liveUserCollection = LiveUserCollection();
LiveChatCollection liveChatCollection = LiveChatCollection();
TargetCollection targetCollection = TargetCollection();
List<BuildContext> buildContextsList = <BuildContext>[];