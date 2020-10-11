import 'package:chat_mobile/data/cases/services/live-chat-collection.dart';
import 'package:chat_mobile/data/entities/target-collection.dart';
import 'package:flutter/material.dart';

import 'package:chat_mobile/ui/pages/tabs.dart';
import 'package:chat_mobile/ui/pages/login.dart';
import 'package:chat_mobile/ui/pages/splash_screen.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/cases/services/auth-service.dart';
import 'package:chat_mobile/data/cases/services/live-user-collection.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:provider/provider.dart';

class SimpleChatApp extends StatefulWidget {
  final ChatComponent _chatComponent = ChatComponent(webSocketAddress);

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
    return MultiProvider(
      providers: [
        ListenableProvider<LiveUserCollection>.value(value: liveUserCollection),
        ListenableProvider<LiveChatCollection>.value(value: liveChatCollection),
        ListenableProvider<TargetCollection>.value(value: targetCollection,)
      ],
      child: ChatComponentWidget(
        widget._chatComponent,
        MaterialApp(
          title: 'Simple Chat',
          theme: ThemeData(
              primarySwatch: Colors.blue,
              scaffoldBackgroundColor: Colors.grey.shade200
          ),
          initialRoute: '/',
          routes: {
            '/': (context) => FutureBuilder<bool>(
                future: authService.checkCode(),
                builder: (ctx, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) return SplashScreen();
                  if(snapshot.data ?? false)
                    return TabsPage(chatComponent: widget._chatComponent);
                  return LoginPage();
                }
            ),
            '/tabs': (context) => TabsPage(chatComponent: widget._chatComponent,),
          },
        ),
      ),
    );
  }
}
