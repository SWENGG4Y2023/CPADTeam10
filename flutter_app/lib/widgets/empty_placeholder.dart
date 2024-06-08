import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/constants/constants.dart';

class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("No Bilty Found"),
          ),
        ],
      ),
    );
  }
}
