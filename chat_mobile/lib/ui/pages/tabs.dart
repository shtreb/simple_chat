import 'package:flutter/material.dart';

import 'package:chat_mobile/ui/pages/create_chat.dart';
import 'package:chat_mobile/ui/widgets/chat_list.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';

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

  @override void initState() {
    tabCtrl = TabController(
        initialIndex: 0,
        length: 2,
        vsync: this
    );
    super.initState();
  }

  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      bottomNavigationBar: TabBar(
        controller: tabCtrl,
        labelColor: Theme.of(context).primaryColor,
        indicatorColor: Theme.of(context).primaryColor,
        tabs: [
          Tab(icon: Icon(Icons.chat_sharp), text: 'chats', iconMargin: EdgeInsets.only(bottom: 2),),
          Tab(icon: Icon(Icons.person_pin_rounded), text: 'friends', iconMargin: EdgeInsets.only(bottom: 2),)
        ],
      ),
      body: TabBarView(
        controller: tabCtrl,
        physics: BouncingScrollPhysics(),
        children: [
          ChatListPage(chatComponent: widget.chatComponent,),
          CreateChatPage(),
        ],
      ),
    );
  }

  @override void dispose() {
    tabCtrl?.dispose();
    super.dispose();
  }

}