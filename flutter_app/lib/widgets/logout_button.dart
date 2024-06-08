import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';

class LogOutButton extends StatelessWidget {
  const LogOutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //getting window size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return InkWell(
      onTap: () async {
        //getting sharedpreferences data
        SharedPref prefs = SharedPref();
        prefs.removeStringDataFromKey("email");
        prefs.removeStringDataFromKey("password");
        prefs.removeStringDataFromKey("token");
        prefs.removeStringDataFromKey("timestamp");
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
            "Log Out",
            style: TextStyle(
              fontSize: 18 * textScaleFactor,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
