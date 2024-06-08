import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/constants/constants.dart';

class InputTextField extends StatelessWidget {
  String labelText;
  bool multiLineSupport;
  //TextEditingController controller;
  InputTextField({Key? key,required this.labelText,required this.multiLineSupport}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //getting scale factor
    double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return TextFormField(
      decoration: textInputDecoration.copyWith(
        labelText: labelText,
        labelStyle: textLabelStyle,
      ),
      minLines: 1,
      maxLines: multiLineSupport?5:1,
      style: textInputStyle.copyWith(
        fontSize: 14*textScaleFactor,
      ),
    );
  }
}
