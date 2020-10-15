import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:chat_mobile/ui/pages/account.dart';
import 'package:chat_mobile/ui/pages/chat_list.dart';
import 'package:chat_mobile/ui/pages/create_chat.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/generated/i18n.dart';

class TabsPage extends StatefulWidget {

  final ChatComponent chatComponent;

  TabsPage({
    Key key,
    this.chatComponent
  }) : super(key: key);

  @override _TabsPageState createState() => _TabsPageState();

}

class _TabsPageState extends State<TabsPage> with TickerProviderStateMixin {

  TabController tabCtrl;

  final ValueNotifier<int> index = ValueNotifier(0);

  @override void initState() {
    tabCtrl = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this,
    );
    tabCtrl.addListener(() => index.value = tabCtrl.index);
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return ValueListenableProvider<int>.value(
      value: index,
      child: Scaffold(
        appBar: AppBar(
          title: Consumer<int>(
            builder: (_, value, __) => Text(
              value == 0 ? S.of(context).tabs_chats : S.of(context).tabs_friends,
              style: Theme.of(context).appBarTheme.textTheme.headline5,),
          ),
          actions: [
            CupertinoButton(
              child: Icon(Icons.person_outline_rounded, color: Theme.of(context).primaryColor,),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AccountPage(),
                ),
              )
            )
          ],
        ),
        bottomNavigationBar: Stack(
          children: [
            Container(
              height: kToolbarHeight,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).primaryColor.withOpacity(.1), width: 1)
              ),
            ),
            SizedBox(
              height: kToolbarHeight,
              child: TabBar(
                controller: tabCtrl,
                indicator: BoxDecoration(),
                indicatorWeight: .1,
                labelPadding: EdgeInsets.all(0),
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(
                    icon: Icon(Icons.chat_outlined),
                    text: S.of(context).tabs_tab_chat,
                    iconMargin: EdgeInsets.only(bottom: 2),),
                  Tab(
                    icon: Icon(Icons.person_pin_outlined),
                    text: S.of(context).tabs_tab_friends,
                    iconMargin: EdgeInsets.only(bottom: 2),)
                ],
              ),
            ),
          ],
        ),
        body: TabBarView(
          controller: tabCtrl,
          physics: ClampingScrollPhysics(),
          children: [
            ChatListPage(chatComponent: widget.chatComponent,),
            CreateChatPage(),
          ],
        ),
      )
    );
  }

  @override void dispose() {
    tabCtrl?.dispose();
    super.dispose();
  }

}