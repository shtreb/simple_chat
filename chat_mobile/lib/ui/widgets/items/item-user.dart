import 'package:flutter/material.dart';
import 'package:chat_models/chat_models.dart';

class ItemUser extends StatelessWidget {
  final User user;
  final bool isChecked;
  final VoidCallback onClick;

  ItemUser({
    this.user,
    this.isChecked,
    this.onClick
  });

  @override Widget build(BuildContext context) => GestureDetector(
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: isChecked ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                shape: BoxShape.circle
            ),
            child: Center(
              child: Text('${user.realName.isEmpty ? 'U' : user.realName[0]}'
                  '${user.realSurname.isEmpty ? 'N' : user.realSurname[0]}',
                style: TextStyle(fontSize: 18),),
            ),
          ),
          const Padding(padding: EdgeInsets.only(left: 16)),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${user.realName.isEmpty ? 'Unknown' : user.realName} '
                  '${user.realSurname.isEmpty ? 'Unknown' :
              user.realSurname}'),
              Text('${user.email.isEmpty ? 'Unknown email' : user.email}',
                style: TextStyle(color: Colors.grey.shade700),)
            ],
          )
        ],
      ),
    ),
    onTap: onClick,
  );

}