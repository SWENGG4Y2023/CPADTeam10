import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';
import 'package:transport_bilty_generator/widgets/logout_button.dart';
import 'package:transport_bilty_generator/widgets/toggle_button.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';

class SettingsScreen extends StatefulWidget {
  final dynamic accountDetails;

  const SettingsScreen({Key? key, this.accountDetails}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    //getting window size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(
          color: Color(0xFFFDFFFC),
        ),
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.accountDetails.name,
                  style: TextStyle(
                    fontSize: 24 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                kIsWeb
                    ? const SizedBox(
                        width: 100,
                        height: 100,
                        child: Icon(
                          Icons.business,
                          size: 70,
                        ),
                      )
                    : ClipRRect(
                        child: Image.network(
                          widget.accountDetails.company.logoURL,
                          fit: BoxFit.scaleDown,
                          width: 70.0,
                          height: 70.0,
                        ),
                      ),
              ],
            ),
            Divider(
              thickness: 1,
              height: screenHeight * 0.05,
            ),
            Row(
              children: [
                const Icon(Icons.language),
                SizedBox(
                  width: screenWidth * 0.038,
                ),
                Text(
                  "change_language".tr,
                  style: TextStyle(
                    fontSize: 18 * textScaleFactor,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const Spacer(),
                LanguageToggleButton(
                    localizationController: localizationController),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.015,
            ),
            InkWell(
              onTap: () async {
                //getting sharedpreferences data
                SharedPref prefs = SharedPref();
                prefs.removeStringDataFromKey("email");
                // Navigator.pushReplacement(
                //     context, MaterialPageRoute(builder: (_) => LogIn()));
                Navigator.popAndPushNamed(context, '/login');
              },
              child: Row(
                children: [
                  const Icon(Icons.logout),
                  SizedBox(
                    width: screenWidth * 0.038,
                  ),
                  Text(
                    "log_out".tr,
                    style: TextStyle(
                      fontSize: 18 * textScaleFactor,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
