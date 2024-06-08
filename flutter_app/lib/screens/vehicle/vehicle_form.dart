import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;

  const VehicleForm({Key? key, required this.vehicle}) : super(key: key);

  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  //setting up variables
  String _vehicleType = '';
  String _vehicleNumber = '';
  bool _marketOrOwn = false;
  String? isVehicleOwn;

  void prefillForm(Vehicle? vehicle) {
    if (vehicle != null) {
      _vehicleType = vehicle.vehicleType;
      _vehicleNumber = vehicle.vehicleNumber;
      _marketOrOwn = vehicle.marketOrOwn ?? false;
      isVehicleOwn = vehicle.marketOrOwn != null
          ? vehicle.marketOrOwn!
              ? "OWN"
              : "MARKET"
          : null;
    }
  }

  @override
  void initState() {
    super.initState();
    prefillForm(widget.vehicle);
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
            "vehicle_form".tr,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //Driver Name
                    TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      initialValue: _vehicleNumber,
                      onChanged: (val) {
                        setState(() {
                          _vehicleNumber = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          labelText: "vehicle_number".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    // Pan No
                    TextFormField(
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      initialValue: _vehicleType,
                      onChanged: (val) {
                        setState(() {
                          _vehicleType = val;
                        });
                      },
                      decoration: textInputDecoration.copyWith(
                          labelText: "vehicle_type".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    Column(
                      children: [
                        RadioListTile(
                          value: "MARKET",
                          groupValue: isVehicleOwn,
                          onChanged: (value) {
                            setState(() {
                              _marketOrOwn = true;
                              isVehicleOwn = value.toString();
                            });
                          },
                          title: const Text(
                            "MARKET",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        RadioListTile(
                          value: "OWN",
                          groupValue: isVehicleOwn,
                          onChanged: (value) {
                            setState(() {
                              _marketOrOwn = false;
                              isVehicleOwn = value.toString();
                            });
                          },
                          title: const Text(
                            "OWN",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
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
                          print(_marketOrOwn);
                          // Creating vehicle class
                          Vehicle vehicle = Vehicle(
                            id: widget.vehicle?.id,
                            vehicleNumber: _vehicleNumber,
                            vehicleType: _vehicleType,
                            marketOrOwn: _marketOrOwn,
                          );
                          // calling backend functions and adding the customer to db
                          BackendAPI backendAPI = BackendAPI();
                          if (widget.vehicle == null) {
                            var result = await backendAPI.addVehicle(vehicle);
                            if (result) {
                              Navigator.pop(context, result);
                              Get.snackbar(
                                "success".tr,
                                "success_message_for_create".tr,
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
                                "error_message_for_create".tr,
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            var result =
                                await backendAPI.updateVehicle(vehicle);
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
