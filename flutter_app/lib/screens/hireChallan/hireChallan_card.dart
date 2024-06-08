import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_download_dialog.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_form.dart';
import 'package:transport_bilty_generator/screens/hireChallan/view_challan_details.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';

class HireChallanCard extends StatelessWidget {
  const HireChallanCard({
    Key? key,
    required this.hireChallan,
    required this.textScaleFactor,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final HireChallan hireChallan;
  final double textScaleFactor;
  final double screenHeight;
  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
        decoration: singleBorderedContainerDecoration,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HireChallanDetails(hireChallan: hireChallan),
              ),
            );
          },
          textColor: Colors.black,
          title: Container(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: kPrimaryColor),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Text(hireChallan.hireChallanNumber!,
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      "loading_date".tr +
                          DateFormat(" dd-MM-yyyy ").format(
                            DateTime.parse(hireChallan.loadingDate!),
                          ),
                      style: TextStyle(
                        fontSize: textScaleFactor * 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              //consigner Details
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "transporter_details".tr + ' : ',
                    style: TextStyle(
                      fontSize: textScaleFactor * 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.005,
                  ),
                  Text(
                    hireChallan.transporter != null
                        ? hireChallan.transporter!.name
                        : "",
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    style: TextStyle(
                      fontSize: textScaleFactor * 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Divider(),
              //person name
              Row(
                children: [
                  Text(
                    "person_name".tr + " : ",
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hireChallan.personName ?? "",
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                    ),
                  ),
                ],
              ),
              //person number
              Row(
                children: [
                  Text(
                    "person_number".tr + " : ",
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    hireChallan.personNumber ?? "",
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                    ),
                  ),
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hireChallan.fromSource != null
                        ? "from".tr + " ${hireChallan.fromSource!} "
                        : "from".tr,
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                    ),
                  ),
                  Text(
                    hireChallan.toDestination != null
                        ? "to".tr + " ${hireChallan.toDestination!} "
                        : "to".tr,
                    style: TextStyle(
                      fontSize: textScaleFactor * 12,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () async {
                        BackendAPI backendAPI = BackendAPI();
                        if(kIsWeb) {
                          await backendAPI.downloadHireChallanPdf(hireChallan.id!, hireChallan.hireChallanNumber!);
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) =>
                                HireChallanDownloadDialog(
                                  hireChallan: hireChallan,
                                ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download)),
                  IconButton(
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HireChallanForm(hireChallan: hireChallan),
                        ),
                      );
                      if (result != false && result != null) {
                        Navigator.popAndPushNamed(
                            context, "/viewAllHireChallan");
                      }
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final result = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => DeleteDialogBox(
                          titleText: hireChallan.hireChallanNumber!,
                          deleteItem: "Hire Challan",
                          deleteObject: hireChallan,
                        ),
                      );
                      if (result == true) {
                        Navigator.popAndPushNamed(
                            context, "/viewAllHireChallan");
                      }
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "created_by".tr + " : ${hireChallan.createdBy?.name ?? ""}",
                    style: TextStyle(fontSize: textScaleFactor * 12),
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                  // const Spacer(),
                  SizedBox(
                    width: screenWidth * 0.02,
                  ),
                  Expanded(
                    child: Text(
                      hireChallan.createdTime != null
                          ? "date".tr +
                              DateFormat(' dd-MM-yyyy hh:mm a ').format(
                                  DateTime.parse(hireChallan.createdTime!)
                                      .toLocal())
                          : "Date",
                      style: TextStyle(fontSize: textScaleFactor * 12),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
