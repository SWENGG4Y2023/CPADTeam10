import 'dart:async';
import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/screens/login.dart';
import 'package:transport_bilty_generator/screens/main_screen.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';

class SplashScreenPage extends StatelessWidget {
  SplashScreenPage({Key? key}) : super(key: key);
  final BackendAPI backendAPI = BackendAPI();
  Future<Widget> loadFromFuture() async {
    BackendAPI backendAPI = BackendAPI();
    SharedPref prefs = SharedPref();
    String? email = await prefs.getStringDataFromKey("email");
    if (email != null) {
      if (await backendAPI.checkTokenValidity() == false) {
        return Future.value(const LogIn());
      }
      await Future.delayed(const Duration(seconds: 3));
      return Future.value(const MainScreen());
    } else {
      return Future.value(const LogIn());
    }
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      // logo: AssetImage("assets/img/profile.jpeg"),
      logo: Image.asset("assets/img/truck-logo.jpeg"),
      backgroundColor: kPrimaryColorLight,
      title: const Text(" Transport Bilty Generator"),
      loadingText: const Text("loading"),
      loaderColor: kButtonYellowColorLight,
      futureNavigator: loadFromFuture(),
    );
  }
}
