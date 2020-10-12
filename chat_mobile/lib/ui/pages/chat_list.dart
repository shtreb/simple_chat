import 'dart:async';
import 'dart:collection';

import 'package:chat_mobile/ui/widgets/items/item-default.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_models/chat_models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_mobile/ui/pages/chat_content.dart';
import 'package:chat_mobile/ui/widgets/items/item-chat.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/cases/services/live-chat-collection.dart';
import 'package:chat_mobile/data/entities/live-collection-state.dart';
import 'package:chat_mobile/flavors/globals.dart';

class ChatListPage extends StatefulWidget {

  final ChatComponent chatComponent;

  ChatListPage({
    Key key,
    @required this.chatComponent
  }) : super(key: key);

  @override _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {

  ScrollController scrollCtrl;
  Set<ChatId> _unreadChats = HashSet<ChatId>();
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;
  RefreshController refreshCtrl;

  @override void initState() {
    scrollCtrl = ScrollController();
    scrollCtrl.addListener(() => liveChatCollection.currentScrollOffset = scrollCtrl.offset);
    refreshCtrl = RefreshController(initialRefresh: false);

    super.initState();

    if(liveChatCollection.currentState == LiveCollectionState.UNKNOWN)
      liveChatCollection.refresh();

    _unreadMessagesSubscription = widget.chatComponent
        .subscribeUnreadMessagesNotification((unreadChatIds) {
      setState(() {
        _unreadChats.clear();
        _unreadChats.addAll(unreadChatIds);
      });
    });
  }

  @override Widget build(BuildContext context) {
    return Consumer<LiveChatCollection>(
      builder: (_, value, __) => SmartRefresher(
          enablePullUp: false,
          enablePullDown: true,
          controller: refreshCtrl,
          header: WaterDropHeader(),
          onRefresh: () async {
            try {
              await liveChatCollection.refresh();
            } catch(_) {
              //TODO add handle error
            }
            refreshCtrl.refreshCompleted();
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 8, 0, 56),
            itemCount: value.list.length,
            itemBuilder: (ctx, int pos) {
              return ItemDefault(
                child: ItemChat(value.list[pos]),
                onClick: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return ChatContentPage(
                        chat: value.list[pos],
                        chatComponent: ChatComponentWidget.of(context).chatComponent,
                      );
                    },
                  ),
                )
              );
            },
          )
      )
    );
  }

  @override void dispose() {
    scrollCtrl?.dispose();
    refreshCtrl?.dispose();
    _unreadMessagesSubscription.cancel();
    super.dispose();
  }
}
