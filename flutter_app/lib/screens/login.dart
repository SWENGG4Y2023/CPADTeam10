// src for login screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/toggle_button.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  // form Global Key
  final _formKey = GlobalKey<FormState>();

  // setting up form variables
  String _email = '';
  String _password = '';
  String _errorCode = '';
  // boolean for loading widget
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset("assets/img/truck-logo.jpeg"),
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      //decoration: containerDecoration,
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'email_errorText'.tr;
                              } else if (!val.contains('@')) {
                                return 'email_errorText'.tr;
                              }
                              return null;
                            },
                            style: textInputStyle,
                            decoration: textInputDecoration.copyWith(
                                hintText: "email_hintText".tr),
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: screenHeight * 0.02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.visiblePassword,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'password_errorText'.tr;
                              } else if (val.length < 6) {
                                return 'password_lengthError'.tr;
                              }
                              return null;
                            },
                            obscureText: true,
                            style: textInputStyle,
                            decoration: textInputDecoration.copyWith(
                                hintText: "password_hintText".tr),
                            onChanged: (val) {
                              setState(() {
                                _password = val;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(double.infinity, 50)),
                          backgroundColor: MaterialStateProperty.all(
                            Colors.black,
                          ),
                        ),
                        onPressed: _loading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  BackendAPI backendApi = BackendAPI();
                                  if (await backendApi.login(
                                          _email, _password) ==
                                      true) {
                                    Navigator.pushReplacementNamed(
                                        context, '/home');
                                  } else {
                                    setState(() {
                                      _loading = false;
                                      _errorCode = "error_text".tr;
                                    });
                                  }
                                }
                              },
                        child: _loading
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "login_button".tr,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Center(
                      child: LanguageToggleButton(
                        localizationController: localizationController,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Center(
                      child: Text(
                        _errorCode,
                        style: TextStyle(
                          fontSize: textScaleFactor * 12,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
