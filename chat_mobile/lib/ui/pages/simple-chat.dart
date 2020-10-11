import 'package:flutter/material.dart';

import 'package:chat_mobile/ui/pages/login.dart';
import 'package:chat_mobile/ui/pages/create_chat.dart';
import 'package:chat_mobile/ui/widgets/chat_list.dart';
import 'package:chat_mobile/cases/chat_component.dart';
import 'package:chat_mobile/flavors/globals.dart' as globals;

class SimpleChatApp extends StatefulWidget {
  final ChatComponent _chatComponent = ChatComponent(globals.webSocketAddress);

  @override
  _SimpleChatAppState createState() => _SimpleChatAppState();
}

class _SimpleChatAppState extends State<SimpleChatApp> {
  @override
  void initState() {
    super.initState();
    widget._chatComponent.connect();
  }

  @override
  void dispose() {
    widget._chatComponent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatComponentWidget(
      widget._chatComponent,
      MaterialApp(
        title: 'Simple Chat',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginPage(),
          '/chat_list': (context) => ChatListPage(
            title: 'Chat list',
            chatComponent: widget._chatComponent,
          ),
          '/create_chat': (context) => CreateChatPage(title: 'Create Chat'),
        },
      ),
    );
  }
}
