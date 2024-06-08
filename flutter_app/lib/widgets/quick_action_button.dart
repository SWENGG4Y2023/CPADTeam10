import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/constants/constants.dart';

SizedBox buildQuickActionsButtons(
    double screenWidth, String title, Function() onPressed, IconData icon) {
  return SizedBox(
    width: screenWidth * 0.25,
    child: TextButton(
      onPressed: onPressed,
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              color: kButtonYellowColorLight,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                icon,
                color: Colors.black,
                size: 32.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1),
                fontSize: 12,
                letterSpacing: 0,
                fontWeight: FontWeight.bold,
                height: 1.34,
              ),
            ),
          )
        ],
      ),
    ),
  );
}
