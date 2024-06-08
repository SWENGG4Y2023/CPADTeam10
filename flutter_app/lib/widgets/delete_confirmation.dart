import 'package:flutter/material.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/models/driver.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/models/vehicle.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/snackbar.dart';
import 'package:get/get.dart';

class DeleteDialogBox extends StatefulWidget {
  final String titleText;
  final String deleteItem;
  var deleteObject;
  DeleteDialogBox(
      {Key? key,
      required this.titleText,
      required this.deleteItem,
      required this.deleteObject})
      : super(key: key);

  @override
  State<DeleteDialogBox> createState() => _DeleteDialogBoxState();
}

class _DeleteDialogBoxState extends State<DeleteDialogBox> {
  BackendAPI backendAPI = BackendAPI();
  Future<dynamic> deleteObjectFunction(var deleteObject) async {
    if (deleteObject is Vehicle) {
      var apiResult = await backendAPI.deleteVehicle(deleteObject.id!);
      return apiResult;
    } else if (deleteObject is Driver) {
      var apiResult = await backendAPI.deleteDriver(deleteObject.id!);
      return apiResult;
    } else if (deleteObject is Customer) {
      print("customer recieved");
      var apiResult = await backendAPI.deleteCustomer(deleteObject.id!);
      return apiResult;
    } else if (deleteObject is Bilty) {
      print("Bilty Received ${deleteObject.id}");
      var apiResult = await backendAPI.deleteBilty(deleteObject.id!);
      return apiResult;
    } else if (deleteObject is HireChallan) {
      var apiResult = await backendAPI.deleteHireChallan(deleteObject.id!);
      return apiResult;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return AlertDialog(
      title: Text(
        "Delete ${widget.deleteItem} ${widget.titleText}",
        style: TextStyle(fontSize: textScaleFactor * 16),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "This will be permanent and the data can't be retrieved back !",
              style: TextStyle(
                  color: Colors.black, fontSize: textScaleFactor * 14),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: const Text("Confirm"),
          onPressed: () async {
            print(widget.deleteObject.id);
            var value = await deleteObjectFunction(widget.deleteObject);
            if (value == true) {
              Get.snackbar(
                "success".tr,
                "success_message_for_delete".tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
              Navigator.of(context).pop(true);
            } else {
              Navigator.of(context).pop(false);
              Get.snackbar(
                "error".tr,
                "error_message_for_delete".tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.black,
                colorText: Colors.white,
              );
            }
          },
        ),
      ],
    );
  }
}
