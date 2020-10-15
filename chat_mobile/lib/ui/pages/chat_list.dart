import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_models/chat_models.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_mobile/ui/pages/chat_content.dart';
import 'package:chat_mobile/ui/widgets/error.dart';
import 'package:chat_mobile/ui/widgets/pull-to-refresh.dart';
import 'package:chat_mobile/ui/widgets/progress-indicator.dart';
import 'package:chat_mobile/ui/widgets/route_aware_widget.dart';
import 'package:chat_mobile/ui/widgets/items/item-chat.dart';
import 'package:chat_mobile/ui/widgets/items/item-default.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/cases/services/live-chat-collection.dart';
import 'package:chat_mobile/data/entities/live-collection-state.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:chat_mobile/generated/i18n.dart';

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
  }

  @override Widget build(BuildContext context) {
    return Consumer<LiveChatCollection>(
      builder: (_, value, __) {
        if(value.currentState == LiveCollectionState.LOADING && value.list.isEmpty)
          return CustomProgressIndicator();

        if(value.currentState == LiveCollectionState.ERROR && value.list.isEmpty)
          return CustomError(
            title: S.of(context).load_list_error,
            action: S.of(context).load_list_repeat,
            callback: () => value.refresh(),
          );

        return PullToRefresh(
          positive: S.of(context).load_list_success,
          negative: S.of(context).load_list_error,
          refreshController: refreshCtrl,
          onRefresh: () async {
            try {
              await liveChatCollection.refresh();
              refreshCtrl.refreshCompleted();
            } catch(_) {
              refreshCtrl.refreshFailed();
            }
          },
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(0, 8, 0, 56),
            itemCount: value.list.length,
            itemBuilder: (ctx, int pos) => ItemDefault(
                child: ItemChat(value.list[pos]),
                onClick: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => RouteAwareWidget(
                      'chat',
                      context: context,
                      child: ChatContentPage(
                        chat: value.list[pos],
                        chatComponent: ChatComponentWidget.of(context).chatComponent,
                      ),
                    ),
                  ),
                )
            ),
          ),
        );
      }
    );
  }

  @override void dispose() {
    scrollCtrl?.dispose();
    refreshCtrl?.dispose();
    _unreadMessagesSubscription?.cancel();
    super.dispose();
  }
}
