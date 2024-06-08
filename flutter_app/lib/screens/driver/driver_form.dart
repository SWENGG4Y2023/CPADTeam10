import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';

class DriverForm extends StatefulWidget {
  final Driver? driver;

  const DriverForm({Key? key, required this.driver}) : super(key: key);

  @override
  State<DriverForm> createState() => _DriverFormState();
}

class _DriverFormState extends State<DriverForm> {
  //setting up variables
  String _driverName = '';
  String _licenseNumber = '';
  String _mobileNumber = '';

  // function to preset the value for the variables
  void prefillForm(Driver? driver) {
    if (driver != null) {
      _driverName = driver.name;
      _licenseNumber = driver.licenseNumber;
      _mobileNumber = driver.mobileNumber;
    }
  }

  @override
  void initState() {
    super.initState();
    prefillForm(widget.driver);
  }

  bool _loading = false;

  // form Global Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //getting screen size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        backgroundColor: kPrimaryColorLight,
        appBar: AppBar(
          title: Text(
            "driver_form".tr,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.normal,
            ),
          ),
          centerTitle: true,
          backgroundColor: kPrimaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Driver Name
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      initialValue: _driverName,
                      onChanged: (val) {
                        setState(() {
                          _driverName = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          labelText: "driver_name".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    // License No
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      initialValue: _licenseNumber,
                      onChanged: (val) {
                        setState(() {
                          _licenseNumber = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          labelText: "license_number".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    // Mobile No
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: _mobileNumber,
                      onChanged: (val) {
                        setState(() {
                          _mobileNumber = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          labelText: "mobile_number".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              ElevatedButton(
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
                          // Creating Customer class
                          Driver driver = Driver(
                              id: widget.driver?.id,
                              licenseNumber: _licenseNumber,
                              mobileNumber: _mobileNumber,
                              name: _driverName);
                          // calling backend functions and adding the customer to db
                          BackendAPI backendAPI = BackendAPI();
                          if (widget.driver == null) {
                            var result = await backendAPI.addDriver(driver);
                            if (result) {
                              Navigator.pop(context, result);
                              Get.snackbar(
                                "success".tr,
                                "success_message_for_create".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                              Navigator.pop(context, result);
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              Get.snackbar(
                                "error".tr,
                                "error_message_for_create".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            var result = await backendAPI.updateDriver(driver);
                            if (result) {
                              Navigator.pop(context, result);
                              Get.snackbar(
                                "success".tr,
                                "success_message_for_update".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            } else {
                              setState(() {
                                _loading = false;
                              });
                              Get.snackbar(
                                "error".tr,
                                "error_message_for_update".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            }
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
                        "submit".tr,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
