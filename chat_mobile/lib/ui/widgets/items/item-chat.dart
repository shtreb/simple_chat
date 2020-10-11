import 'package:chat_mobile/flavors/globals.dart';
import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';

class ItemChat extends StatelessWidget {

  final Chat chat;
  final VoidCallback onClick;

  ItemChat(this.chat, this.onClick);

  @override Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColorLight
              ),
              child: Center(
                child: Text(chat.members.length.toString(), style: TextStyle(fontSize: 18),),
              ),
            ),
            const Padding(padding: EdgeInsets.only(left: 16)),
            RichText(
              text: TextSpan(
                children: chat.members.map((e) {
                  bool isTarget = targetCollection.hasTarget(e);
                  return TextSpan(
                    text: '${e.realName} ${e.realSurname}'
                        '${chat.members.indexOf(e) != chat.members.length-1 ? ', ' : ''}',
                    style: TextStyle(
                      fontWeight: isTarget ? FontWeight.w600 : FontWeight.normal,
                      fontSize: isTarget ? 15 : 16
                    )
                  );
                }).toList(),
                style: TextStyle(
                  color: Colors.black
                )
              ),
            )
          ],
        )
      ),
      onTap: onClick,
    );
  }

}