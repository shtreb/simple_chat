import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';

class ItemUser extends StatelessWidget {
  final User user;
  final bool isChecked;

  ItemUser({
    this.user,
    this.isChecked,
  });

  @override Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.max,
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
            color: isChecked ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
            shape: BoxShape.circle
        ),
        child: Center(
          child: Text('${user.realName.isEmpty ? 'U' : user.realName[0]}'
              '${user.realSurname.isEmpty ? 'N' : user.realSurname[0]}',
            style: TextStyle(fontSize: 18, color: isChecked ? Colors.white : Colors.black),),
        ),
      ),
      const Padding(padding: EdgeInsets.only(left: 16)),
      Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user.realName.isEmpty ? 'Unknown' : user.realName} '
                  '${user.realSurname.isEmpty ? 'Unknown' :
              user.realSurname}',
                  style: Theme.of(context).textTheme.bodyText1.copyWith(
                      color: isChecked ? Colors.white : Theme.of(context).textTheme.bodyText1.color
                  )
              ),
              Text('${user.email.isEmpty ? 'Unknown email' : user.email}',
                style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: isChecked ? Colors.white.withOpacity(.6) : Theme.of(context).textTheme.bodyText1.color
                ),)
            ],
          )
      )
    ],
  );

}