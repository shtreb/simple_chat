import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneFormat extends FilteringTextInputFormatter {
  PhoneFormat(Pattern filterPattern) :
        super(filterPattern, allow: true);

  @override TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {

    if(newValue == null || newValue.text.isEmpty || filterPattern.allMatches(newValue.text).isNotEmpty) {
      return newValue;
    } else {
      return oldValue;
    }
  }
}