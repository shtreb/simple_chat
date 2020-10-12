import 'package:flutter/material.dart';

class ItemDefault extends StatelessWidget {

  final Widget child;
  final bool isChecked;
  final VoidCallback onClick;

  ItemDefault({
    @required this.child,
    this.isChecked = false,
    this.onClick
  });

  @override Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
              color: isChecked ? Theme.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: <BoxShadow> [
                BoxShadow(
                    color: isChecked ? Theme.of(context).primaryColor : Theme.of(context).shadowColor,
                    blurRadius: 16,
                    offset: Offset(0, 24),
                    spreadRadius: -20
                ).scale(1)
              ]
          ),
          child: child,
        ),
      ),
      onTap: onClick,
    );
  }

}