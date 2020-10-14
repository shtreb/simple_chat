import 'package:flutter/material.dart';

class Bubble extends StatelessWidget {

  final String message, time, avatar, name;
  final isMe;
  
  Bubble({
    this.message,
    this.time,
    this.isMe,
    this.name,
    this.avatar
  });

  @override Widget build(BuildContext context) {
    final bg = isMe ? Theme.of(context).primaryColorLight.withOpacity(.5) : Colors.black.withOpacity(.05);
    final align = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final radius = isMe
        ? BorderRadius.only(
          topLeft: Radius.circular(14.0),
          topRight: Radius.circular(14.0),
          bottomLeft: Radius.circular(14.0),
        )
            : BorderRadius.only(
          topRight: Radius.circular(14.0),
          bottomLeft: Radius.circular(14.0),
          bottomRight: Radius.circular(14.0),
        );

    return Row(
      mainAxisAlignment: align,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Offstage(
          offstage: isMe,
          child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Text(avatar, style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(
                  color: Colors.white,
                  fontSize: 14
              ),),
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(36)
              ),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Offstage(
              offstage: isMe,
              child: Text(name.isEmpty ? 'Unknown' : name, style: Theme.of(context).textTheme.bodyText1.copyWith(
                color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.6),
                fontSize: 12
              ),),
            ),
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(3.0),
                  padding: const EdgeInsets.fromLTRB(16.0, 8, 10, 8),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: radius,
                  ),
                  child: Stack(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 48.0),
                        child: Text(message, style: Theme.of(context).textTheme.bodyText1,),
                      ),
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,
                        child: Row(
                          children: <Widget>[
                            Text(time,
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 10.0,
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ],
    );
  }
}