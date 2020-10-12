import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';

import 'package:chat_mobile/flavors/globals.dart';

class ItemChat extends StatelessWidget {

  final Chat chat;

  ItemChat(this.chat);

  @override Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).primaryColorLight
        ),
        child: Center(
          child: Text(chat.members.length.toString(), style: TextStyle(
              fontSize: 18, color: Colors.black),),
        ),
      ),
      const Padding(padding: EdgeInsets.only(left: 16)),
      Flexible(
        child: RichText(
          text: TextSpan(
              children: chat.members.map((e) {
                bool isTarget = targetCollection.hasTarget(e);
                return TextSpan(
                    text: '${e.realName} ${e.realSurname}'
                        '${chat.members.indexOf(e) != chat.members.length-1 ? ', ' : ''}',
                    style: Theme.of(context).textTheme.bodyText1.copyWith(
                        fontWeight: isTarget ? FontWeight.w800 : Theme.of(context).textTheme.bodyText1.fontWeight,
                        fontSize: isTarget ? 18 : Theme.of(context).textTheme.bodyText1.fontSize
                    )
                );
              }).toList(),
              style: Theme.of(context).textTheme.bodyText2
          ),
        ),
      )
    ],
  );

}