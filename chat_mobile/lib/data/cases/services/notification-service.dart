import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/entities/live-collection-state.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:chat_mobile/ui/pages/chat_content.dart';
import 'package:chat_mobile/ui/widgets/route_aware_widget.dart';
import 'package:chat_models/chat_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

var notificationService = NotificationService();

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void init() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_message');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<dynamic> onSelectNotification(String payload) async {
    if(currentUser == null) return;
    if(liveChatCollection.currentState == LiveCollectionState.UNKNOWN) {
      await liveChatCollection.refresh();
    }

    debugPrint(payload);

    List<Chat> chats = liveChatCollection.list ?? [];
    chats = chats.where((element) => element.id.toString() != payload).toList();

    if(chats.isEmpty) return;

    Navigator.of(buildContextsList.first).push(
      MaterialPageRoute(
        builder: (context) => RouteAwareWidget(
          'chat',
          context: context,
          child: ChatContentPage(
            chat: chats.first,
            chatComponent: ChatComponentWidget.of(context).chatComponent,
          ),
        ),
      )
    );
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'com.custom.channel',
        title,
        body,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(id, title, body, platformChannelSpecifics, payload: payload);
  }
}