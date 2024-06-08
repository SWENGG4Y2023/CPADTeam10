import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/screens/driver/driver_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class ViewDrivers extends StatefulWidget {
  const ViewDrivers({Key? key}) : super(key: key);

  @override
  State<ViewDrivers> createState() => _ViewDriversState();
}

class _ViewDriversState extends State<ViewDrivers> {
  late Future<List<dynamic>?> futureDriver;

  BackendAPI backendAPI = BackendAPI();

  @override
  void initState() {
    futureDriver = backendAPI.getAllDrivers();
    super.initState();
  }

  late final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        backgroundColor: kPrimaryColorLight,
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const DriverForm(driver: null)));
            if (result == true) {
              setState(() {
                futureDriver = backendAPI.getAllDrivers();
              });
            }
          },
        ),
        appBar: AppBar(
          title: Text(
            "driver".tr,
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
        body: FutureBuilder<List?>(
            future: futureDriver,
            builder: (context, AsyncSnapshot<List?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Column(
                          children: [
                            ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                Driver driver = snapshot.data![i];
                                return Slidable(
                                  key: ValueKey(i),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          var result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DriverForm(
                                                          driver: driver)));
                                          if (result == true) {
                                            setState(() {
                                              futureDriver =
                                                  backendAPI.getAllDrivers();
                                            });
                                          }
                                        },
                                        backgroundColor: kPrimaryColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: "Edit",
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          final result = await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  DeleteDialogBox(
                                                    titleText: driver.name,
                                                    deleteItem: "Driver",
                                                    deleteObject: driver,
                                                  ));
                                          if (result == true) {
                                            setState(() {
                                              futureDriver =
                                                  backendAPI.getAllDrivers();
                                            });
                                          }
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: containerDecoration,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      // onTap: () {
                                      //   showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) =>
                                      //           DriverCard(driver: driver));
                                      // },
                                      title: Text(
                                        driver.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      subtitle: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: screenHeight * 0.002,
                                          ),
                                          Text(
                                            "license_number".tr +
                                                " " +
                                                driver.licenseNumber
                                                    .toString()
                                                    .toUpperCase(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: screenHeight * 0.003,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Icon(
                                                Icons.call,
                                                size: 17,
                                              ),
                                              const SizedBox(
                                                width: 4,
                                              ),
                                              Text(
                                                driver.mobileNumber
                                                    .toString()
                                                    .toUpperCase(),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      leading: const Icon(
                                        Icons.person,
                                        color: kPrimaryColor,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
                                futureDriver = backendAPI.getAllDrivers();
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
                                futureDriver = backendAPI.getAllDrivers();
                              });
                            },
                            icon: const Icon(Icons.cached),
                          ),
                        ],
                      ),
                    );
                  }
              }
            }),
      );
    });
  }
}
