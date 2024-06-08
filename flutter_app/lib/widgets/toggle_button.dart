import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/constants/app_constants.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';

class LanguageToggleButton extends StatefulWidget {
  final LocalizationController localizationController;

  const LanguageToggleButton({
    Key? key,
    required this.localizationController,
  }) : super(key: key);
  @override
  State<LanguageToggleButton> createState() => LanguageToggleButtonState();
}

class LanguageToggleButtonState extends State<LanguageToggleButton> {
  @override
  void initState() {
    generateSelectedBoolList();
    super.initState();
  }

  List<bool> isSelected = <bool>[true, false];

  void generateSelectedBoolList() async {
    int index = await widget.localizationController.getCurrentLanguageIndex();
    if (index == 0) {
      setState(() {
        isSelected = [true, false];
      });
    } else {
      setState(() {
        isSelected = [false, true];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //getting window size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);

    return SizedBox(
      height: screenHeight * 0.05,
      child: ToggleButtons(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        children: const <Widget>[
          Text("en"),
          Text("hi"),
        ],
        onPressed: (int index) {
          // setting selected button true
          setState(() {
            for (int buttonIndex = 0;
                buttonIndex < isSelected.length;
                buttonIndex++) {
              if (buttonIndex == index) {
                isSelected[buttonIndex] = true;
              } else {
                isSelected[buttonIndex] = false;
              }
            }
          });
          widget.localizationController.setLangugae(Locale(
            AppConstants.languages[index].languageCode,
            AppConstants.languages[index].countryCode,
          ));
          widget.localizationController.setSelectIndex(index);
        },
        isSelected: isSelected,
        fillColor: kCardShadowColorLight,
        selectedColor: Colors.black,
        selectedBorderColor: kButtonYellowColorLight,
      ),
    );
  }
}
