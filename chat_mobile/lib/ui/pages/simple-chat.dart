import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:chat_mobile/ui/pages/tabs.dart';
import 'package:chat_mobile/ui/pages/login.dart';
import 'package:chat_mobile/ui/pages/account.dart';
import 'package:chat_mobile/ui/pages/splash_screen.dart';
import 'package:chat_mobile/ui/widgets/route_aware_widget.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/cases/services/auth-service.dart';
import 'package:chat_mobile/data/cases/services/notification-service.dart';
import 'package:chat_mobile/data/cases/services/live-chat-collection.dart';
import 'package:chat_mobile/data/cases/services/live-user-collection.dart';
import 'package:chat_mobile/data/entities/target-collection.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:chat_mobile/generated/i18n.dart';

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
    widget._chatComponent.subscribeUnreadMessagesNotification((unreadChatIds) {
      if(unreadChatIds == null || unreadChatIds.isEmpty || currentUser == null) return;
      notificationService.onDidReceiveLocalNotification(
          0,
          S.of(context).notify_header,
          S.of(context).notify_body,
          unreadChatIds.first.toString()
      );
    });
    notificationService.init();
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
          title: "Simple chat",
          theme: ThemeData(
            primaryColor: Color(0xFF7175EB),
            primaryColorDark: Color(0xFF5759C0),
            primaryColorLight: Color(0xFFBCBFEB),
            scaffoldBackgroundColor: Color(0xFFF1F7FF),
            shadowColor: Colors.black.withOpacity(.25),
            buttonColor: Color(0xFF7175EB),
            buttonTheme: ButtonThemeData(
              height: 48,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(56)),
              textTheme: ButtonTextTheme.primary,
              splashColor: Colors.transparent,
              highlightColor: Color(0xFF7175EB).withOpacity(.7),
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              buttonColor: Color(0xFF7175EB),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: Color(0xFF7175EB)
            ),
            appBarTheme: AppBarTheme(
              color: Color(0xFFF1F7FF),
              elevation: 1,
              iconTheme: IconThemeData(
                color: Color(0xFF5F5F87)
              ),
              textTheme: TextTheme(
                headline3: TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.w600
                ),
                headline2: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w700
                ),
                headline5: TextStyle(
                    color: Color(0xFF5F5F87),
                    fontSize: 24,
                    fontWeight: FontWeight.w700
                ),
                headline6: TextStyle(
                  color: Color(0xFF5F5F87),
                  fontSize: 18,
                  fontWeight: FontWeight.w700
                )
              )
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 16,
                color: Color(0xFF5F5F87),
              ),
              bodyText2: TextStyle(
                fontSize: 14,
                color: Color(0xFF8E9CB0)
              ),
              button: TextStyle(
                fontSize: 16,
              )
            )
          ),
          localizationsDelegates: [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate
          ],
          supportedLocales: S.delegate.supportedLocales,
          initialRoute: '/',
          routes: {
            '/': (context) => FutureBuilder<bool>(
                future: authService.checkCode(),
                builder: (ctx, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) return SplashScreen();
                  bool isAuth = snapshot.data ?? false;
                  return RouteAwareWidget(isAuth ? 'tabs' : 'login',
                      context: context,
                      child: isAuth ?
                        TabsPage(chatComponent: widget._chatComponent) :
                        LoginPage());
                }
            ),
            '/tabs': (context) => RouteAwareWidget(
              'tabs',
              context: context,
              child: TabsPage(chatComponent: widget._chatComponent,)
            ),
            '/account': (context) => RouteAwareWidget(
                'account',
                context: context,
                child: AccountPage()
            )
          },
        ),
      ),
    );
  }
}
