import 'package:chat_mobile/data/entities/target-collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_models/chat_models.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_mobile/ui/pages/chat_content.dart';
import 'package:chat_mobile/ui/widgets/items/item-user.dart';
import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/data/cases/services/live-user-collection.dart';
import 'package:chat_mobile/data/entities/checkable-user.dart';
import 'package:chat_mobile/data/entities/live-collection-state.dart';
import 'package:chat_mobile/flavors/globals.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CreateChatPage extends StatefulWidget {

  CreateChatPage({Key key,}) : super(key: key);

  @override _CreateChatPageState createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {

  RefreshController refreshCtrl = RefreshController(initialRefresh: false);

  ValueNotifier<bool> hasTarget;

  ScrollController scrollCtrl;

  @override void initState() {

    hasTarget = ValueNotifier(targetCollection.listTarget.isNotEmpty);

    scrollCtrl = ScrollController(initialScrollOffset: liveUserCollection.currentScrollOffset);
    scrollCtrl.addListener(() => liveUserCollection.currentScrollOffset = scrollCtrl.offset);

    super.initState();

    if(liveUserCollection.currentState == LiveCollectionState.UNKNOWN)
      liveUserCollection.load();
  }

  @override Widget build(BuildContext context) {
    return ValueListenableProvider<bool>.value(
      value: hasTarget,
      child: Scaffold(
        body: Consumer<LiveUserCollection>(
          builder: (_, value, __) {
            return SmartRefresher(
                enablePullUp: false,
                enablePullDown: true,
                controller: refreshCtrl,
                header: WaterDropHeader(),
                onRefresh: () async {
                  try {
                    await liveUserCollection.refresh();
                  } catch(_) {
                    //TODO add handle error
                  }
                  refreshCtrl.refreshCompleted();
                },
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: scrollCtrl,
                  itemCount: value.list.length,
                  itemBuilder: (BuildContext context, int index) => Consumer<TargetCollection>(
                      builder: (_, _value, __) => ItemUser(
                        user: value.list[index],
                        isChecked: _value.hasTarget(value.list[index]),
                        onClick: () {
                          targetCollection.addTarget(value.list[index]);
                          hasTarget.value = targetCollection.listTarget.isNotEmpty;
                        },
                      )
                  ),
                )
            );
          },
        ),
        floatingActionButton: Consumer<bool>(
          builder: (_, value, __) => value ? FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => createChat(),
          ) : SizedBox.shrink(),
        ),
      ),
    );
  }

  void createChat() async {
    var _checkedCounterparts = targetCollection.listTarget;
    if (_checkedCounterparts.isNotEmpty) {
      try {
        ChatsClient chatsClient = ChatsClient(MobileApiClient());
        Chat createdChat = await chatsClient.create(
            Chat(members: _checkedCounterparts..add(currentUser)));
        Navigator.push(context,
          MaterialPageRoute(
            builder: (BuildContext context) => ChatContentPage(
                  chat: createdChat,
                  chatComponent: ChatComponentWidget.of(context).chatComponent,
                ),
          ),
        );
      } on Exception catch (e) {
        print('Chat creation failed');
        print(e);
      }
    }
  }

  @override void dispose() {
    scrollCtrl?.dispose();
    super.dispose();
  }
}