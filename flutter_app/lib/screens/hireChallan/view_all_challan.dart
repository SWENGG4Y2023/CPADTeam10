import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_card.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class ViewAllHireChallan extends StatefulWidget {
  const ViewAllHireChallan({Key? key}) : super(key: key);

  @override
  State<ViewAllHireChallan> createState() => _ViewAllHireChallanState();
}

class _ViewAllHireChallanState extends State<ViewAllHireChallan> {
  late Future<dynamic> futureHireChallan;
  final BackendAPI backendAPI = BackendAPI();

  @override
  void initState() {
    futureHireChallan = backendAPI.getAllHireChallan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "view_all_challan".tr,
            style: const TextStyle(
              fontSize: 20,
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
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh_sharp),
              onPressed: () {
                setState(() {
                  futureHireChallan = backendAPI.getAllHireChallan();
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: futureHireChallan,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        snapshot.data!.length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, i) {
                                  HireChallan hireChallan = snapshot.data![i];
                                  return HireChallanCard(
                                      hireChallan: hireChallan,
                                      textScaleFactor: textScaleFactor,
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth);
                                },
                              )
                            : Center(
                                child: Column(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("No HireChallan Found"),
                                    ),
                                  ],
                                ),
                              ),
                      ],
                    );
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Network Error has Occurred"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                futureHireChallan =
                                    backendAPI.getAllHireChallan();
                              });
                            },
                            icon: const Icon(Icons.cached),
                          ),
                        ],
                      ),
                    );
                  }
                default:
                  if (snapshot.hasError) {
                    return Text("${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return Text("${snapshot.data}");
                  } else {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text("Network Error has Occurred"),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                futureHireChallan =
                                    backendAPI.getAllHireChallan();
                              });
                            },
                            icon: const Icon(Icons.cached),
                          ),
                        ],
                      ),
                    );
                  }
              }
            },
          ),
        ),
      );
    });
  }
}
