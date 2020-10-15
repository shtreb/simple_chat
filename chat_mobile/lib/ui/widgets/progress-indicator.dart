import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  @override Widget build(BuildContext context) => Center(
    child: SizedBox(
      width: 80,
      height: 80,
      child: CircularProgressIndicator(),
    ),
  );
}