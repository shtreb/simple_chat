import 'dart:async';
import 'dart:collection';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:chat_api_client/chat_api_client.dart';

import 'package:chat_models/chat_models.dart';
import 'package:chat_mobile/ui/widgets/items/item-bubble.dart';
import 'package:chat_mobile/data/cases/api_client.dart';
import 'package:chat_mobile/data/cases/chat_component.dart';
import 'package:chat_mobile/flavors/globals.dart' as globals;
import 'package:chat_mobile/generated/i18n.dart';

class ChatContentPage extends StatefulWidget {
  ChatContentPage({Key key, @required this.chat, @required this.chatComponent})
      : super(key: key);
  final ChatComponent chatComponent;
  final Chat chat;
  final formatter = DateFormat('HH:mm');

  @override
  _ChatContentPageState createState() => _ChatContentPageState();
}

class _ChatContentPageState extends State<ChatContentPage> {
  String _title;
  var _messages = <Message>[];
  final _sendMessageTextController = TextEditingController();
  StreamSubscription<Message> _messagesSubscription;
  StreamSubscription<Set<ChatId>> _unreadMessagesSubscription;
  Set<ChatId> _unreadChats = HashSet<ChatId>();
  ScrollController scrollCtrl;

  @override
  void initState() {
    scrollCtrl = ScrollController();
    super.initState();
    _title = widget.chat.members
        .where((user) => user.id != globals.currentUser.id)
        .map((user) => user.name)
        .join(", ");
    refreshChatContent();

    _messagesSubscription = widget.chatComponent.subscribeMessages((receivedMessage) {
      setState(() => _messages.add(receivedMessage));
    }, widget.chat.id);
  }

  @override
  void dispose() {
    _sendMessageTextController.dispose();
    _messagesSubscription.cancel();
    _unreadMessagesSubscription.cancel();
    super.dispose();
  }

  void refreshChatContent() async {
    try {
      List<Message> msgList = await MessagesClient(MobileApiClient()).read(widget.chat.id);
      setState(() => _messages = msgList.reversed.toList());
    } on Exception catch (e) {
      print('Failed to get list of messages');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(_title),
    ),
    body: SafeArea(
      bottom: true,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              reverse: true,
              controller: scrollCtrl,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildListTile(_messages[index]);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Theme.of(context).primaryColorLight.withOpacity(.5), width: .5),
                        boxShadow: <BoxShadow> [
                          BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(.1),
                              blurRadius: 6
                          )
                        ]
                    ),
                    child: TextField(
                      controller: _sendMessageTextController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: S.of(context).chat_enter_message,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.only(left: 8)),
                SizedBox(
                  height: 48,
                  child: FloatingActionButton(
                    heroTag: 'sendMessage',
                    splashColor: Colors.transparent,
                    child: const Icon(Icons.send),
                    onPressed: () {
                      if (_sendMessageTextController.text.isNotEmpty)
                        send(_sendMessageTextController.text);
                    },
                  ),
                )
              ],
            ),
          ),
          const Padding(padding: EdgeInsets.only(bottom: 16))
        ],
      ),
    ),
  );

  Widget _buildListTile(Message message) {
    var isMyMessage = message.author.id == globals.currentUser.id;
    var messageTime = widget.formatter.format(message.createdAt);
    String st = message.author.realName.isNotEmpty ? message.author.realName[0] : 'U';
    String nd = message.author.realSurname.isNotEmpty ? message.author.realSurname[1] : 'N';
    return Bubble(
      message: message.text,
      isMe: isMyMessage,
      time: messageTime,
      name: message.author.realName,
      avatar: st+nd
    );
  }

  send(String message) async {
    final newMessage = Message(
        chat: widget.chat.id,
        author: globals.currentUser,
        text: message,
        createdAt: DateTime.now());
    try {
      await MessagesClient(MobileApiClient()).create(newMessage);
      _sendMessageTextController.clear();
    } on Exception catch (e) {
      print('Sending message failed');
      print(e);
    }
  }
}
