import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';

class AddResources extends StatefulWidget {
  const AddResources({Key? key}) : super(key: key);

  @override
  State<AddResources> createState() => _AddResourcesState();
}

class _AddResourcesState extends State<AddResources> {
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
      return Scaffold(
        backgroundColor: kPrimaryColorLight,
        appBar: AppBar(
          title: Text(
            "resources".tr,
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Container(
                  decoration: containerDecoration,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(
                      Icons.category_rounded,
                      color: kPrimaryColor,
                      size: 36,
                    ),
                    title: Text(
                      "customer".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Get.toNamed("/viewCustomers");
                    },
                  ),
                ),
                Container(
                  decoration: containerDecoration,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.only(top: 20),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(
                      Icons.category_rounded,
                      color: kPrimaryColor,
                      size: 36,
                    ),
                    title: Text(
                      "driver".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/viewDrivers');
                    },
                  ),
                ),
                Container(
                  decoration: containerDecoration,
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  margin: const EdgeInsets.only(top: 20),
                  child: ListTile(
                    style: ListTileStyle.drawer,
                    leading: const Icon(
                      Icons.category_rounded,
                      color: kPrimaryColor,
                      size: 36,
                    ),
                    title: Text(
                      "vehicle".tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                    ),
                    onTap: () {
                      Get.toNamed("/viewVehicles");
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
