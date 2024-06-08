import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';
import 'package:transport_bilty_generator/screens/vehicle/vehicle_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';
import 'package:transport_bilty_generator/widgets/snackbar.dart';

class ViewVehicles extends StatefulWidget {
  const ViewVehicles({Key? key}) : super(key: key);

  @override
  State<ViewVehicles> createState() => _ViewVehiclesState();
}

class _ViewVehiclesState extends State<ViewVehicles> {
  late Future<List<dynamic>?> futureVehicle;
  BackendAPI backendAPI = BackendAPI();

  @override
  void initState() {
    futureVehicle = backendAPI.getAllVechiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
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
                      builder: (context) => const VehicleForm(vehicle: null)));
              if (result == true) {
                setState(() {
                  futureVehicle = backendAPI.getAllVechiles();
                });
              }
            },
          ),
          appBar: AppBar(
            title: Text(
              "vehicle".tr,
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
              future: futureVehicle,
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
                                  Vehicle vehicle = snapshot.data![i];
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
                                                        VehicleForm(
                                                            vehicle: vehicle)));

                                            if (result == true) {
                                              setState(() {
                                                futureVehicle =
                                                    backendAPI.getAllVechiles();
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
                                                builder:
                                                    (BuildContext context) =>
                                                        DeleteDialogBox(
                                                          titleText: vehicle
                                                              .vehicleNumber,
                                                          deleteItem: "Vehicle",
                                                          deleteObject: vehicle,
                                                        ));
                                            if (result == true) {
                                              setState(() {
                                                futureVehicle =
                                                    backendAPI.getAllVechiles();
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
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ListTile(
                                        title: Row(
                                          children: [
                                            Text(
                                              vehicle.vehicleNumber,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Spacer(),
                                            vehicle.marketOrOwn != null
                                                ? vehicle.marketOrOwn!
                                                    ? Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            redOutlineContainerDecoration,
                                                        child: Text(
                                                          "MARKET",
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )
                                                    : Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        decoration:
                                                            redOutlineContainerDecoration,
                                                        child: Text(
                                                          'OWN',
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      )
                                                : SizedBox(),
                                          ],
                                        ),
                                        subtitle: Text(
                                          vehicle.vehicleType,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        leading: const Icon(
                                          Icons.local_shipping,
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
                                  futureVehicle = backendAPI.getAllVechiles();
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
                                  futureVehicle = backendAPI.getAllVechiles();
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
      },
    );
  }
}
