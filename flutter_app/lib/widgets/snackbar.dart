import 'package:flutter/material.dart';

SnackBar showSnackBar(String content) {
  return SnackBar(
    behavior: SnackBarBehavior.fixed,
    dismissDirection: DismissDirection.horizontal,
    duration: Duration(seconds: 2),
    content: Container(
      child: Text(content),
    ),
  );
}
