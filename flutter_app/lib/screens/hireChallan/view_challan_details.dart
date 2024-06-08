import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_download_dialog.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';

class HireChallanDetails extends StatefulWidget {
  final HireChallan hireChallan;

  const HireChallanDetails({Key? key, required this.hireChallan})
      : super(key: key);

  @override
  State<HireChallanDetails> createState() => _HireChallanDetailsState();
}

class _HireChallanDetailsState extends State<HireChallanDetails> {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;
    //bool isAdvance = widget.hireChallan.isAdvance ?? true;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Hire Challan Details",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.normal,
          ),
        ),
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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: screenHeight * 0.01, horizontal: screenWidth * 0.03),
          child: Column(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: containerDecoration,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: kPrimaryColor),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Text(widget.hireChallan.hireChallanNumber!,
                                style: TextStyle(
                                  fontSize: textScaleFactor * 14,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                "date".tr +
                                    " : " +
                                    DateFormat('dd-MM-yyyy').format(
                                        DateTime.tryParse(widget
                                                    .hireChallan.createdTime ??
                                                "") ??
                                            DateTime.now()),
                                style: TextStyle(
                                  fontSize: textScaleFactor * 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        //consigner Details
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "transporter_details".tr + " : ",
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              widget.hireChallan.transporter != null
                                  ? widget.hireChallan.transporter!.name
                                  : "",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.hireChallan.fromSource != null
                                  ? "from".tr +
                                      " ${widget.hireChallan.fromSource!} "
                                  : "from".tr,
                              style: TextStyle(fontSize: textScaleFactor * 12),
                            ),
                            Text(
                              widget.hireChallan.toDestination != null
                                  ? "to".tr +
                                      " ${widget.hireChallan.toDestination!} "
                                  : "to".tr,
                              style: TextStyle(fontSize: textScaleFactor * 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HireChallanForm(
                                    hireChallan: widget.hireChallan)));
                        if (result != false && result != null) {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          //Navigator.pop(context);
                          Navigator.pushNamed(context, "/viewAllHireChallan");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      HireChallanDetails(hireChallan: result)));
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit,
                              size: textScaleFactor * 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "edit".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: textScaleFactor * 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () async {
                        final result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => DeleteDialogBox(
                                  titleText:
                                      widget.hireChallan.hireChallanNumber!,
                                  deleteItem: "Hire Challan",
                                  deleteObject: widget.hireChallan,
                                ));
                        if (result == true) {
                          Navigator.popAndPushNamed(
                              context, "/viewAllHireChallan");
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.delete,
                              color: Colors.red,
                              size: textScaleFactor * 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "delete".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: textScaleFactor * 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    OutlinedButton(
                        onPressed: () async {
                          BackendAPI backendAPI = BackendAPI();
                          if(kIsWeb) {
                            await backendAPI.downloadHireChallanPdf(widget.hireChallan.id!, widget.hireChallan.hireChallanNumber!);
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) =>
                                  HireChallanDownloadDialog(
                                    hireChallan: widget.hireChallan,
                                  ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.download,
                              size: textScaleFactor * 14,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "download".tr,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: textScaleFactor * 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ))
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Container(
                decoration: containerDecoration,
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "loading_date".tr + " : ",
                          style: TextStyle(
                            fontSize: textScaleFactor * 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.hireChallan.loadingDate != null
                              ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                  widget.hireChallan.loadingDate!))
                              : "",
                          style: TextStyle(
                            fontSize: textScaleFactor * 11,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "unload_date".tr + " : ",
                          style: TextStyle(
                            fontSize: textScaleFactor * 11,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.hireChallan.unloadingDate != null
                              ? DateFormat('dd-MM-yyyy').format(DateTime.parse(
                                  widget.hireChallan.unloadingDate!))
                              : "",
                          style: TextStyle(
                            fontSize: textScaleFactor * 11,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "weight".tr + " : ",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.hireChallan.weight ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "rate".tr + " : ",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.hireChallan.rate ?? "",
                          style: const TextStyle(
                            fontSize: 12,
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
              Container(
                decoration: containerDecoration,
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // invoice details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "person_details".tr,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        Text(
                          "person_name".tr +
                              " : ${widget.hireChallan.personName ?? ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "person_number".tr +
                              " : ${widget.hireChallan.personNumber ?? ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "person_designation".tr +
                              " : ${widget.hireChallan.personDesignation ?? ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    // Text(
                    //   "Description : ",
                    //   style: TextStyle(
                    //     fontSize: textScaleFactor * 14,
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                    // driver and vehicle
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "driver".tr,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "vehicle_details".tr,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.hireChallan.driver != null
                                      ? widget.hireChallan.driver!.name
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.hireChallan.driver != null
                                      ? widget.hireChallan.driver!.licenseNumber
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.hireChallan.driver != null
                                      ? widget.hireChallan.driver!.mobileNumber
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.hireChallan.vehicle != null
                                      ? widget
                                          .hireChallan.vehicle!.vehicleNumber
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.hireChallan.vehicle != null
                                      ? widget.hireChallan.vehicle!.vehicleType
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    // receiving details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "freight_details".tr,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        Row(
                          children: [
                            Text(
                              "total_freight".tr +
                                  " : (${widget.hireChallan.totalFreightDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hireChallan.totalFreightDate!)) : ""})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              " ${widget.hireChallan.totalFreight ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    //value details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //freight
                        // bilty charges
                        SizedBox(
                          height: screenHeight * 0.003,
                        ),

                        Row(
                          children: [
                            Text(
                              "advance_in_bank".tr +
                                  " (${widget.hireChallan.advanceInBankDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hireChallan.advanceInBankDate!)) : ""})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.advanceInBank ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "advance_in_cash".tr +
                                  " (${widget.hireChallan.advanceInCashDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hireChallan.advanceInCashDate!)) : ""})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.advanceInCash ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              "driver_cash_by_party".tr +
                                  " (${widget.hireChallan.driveAdvanceCashbyPartyDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hireChallan.driveAdvanceCashbyPartyDate!)) : ""})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.driveAdvanceCashbyParty ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              "total_advance".tr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.totalAdvance ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "tds".tr + " : ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.tds ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "balance".tr + " : ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.isBalance ? widget.hireChallan.balance ?? "" : widget.hireChallan.balanceType ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "total_deduction".tr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.totalDeduction ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "total_balance_paid".tr +
                                  " (${widget.hireChallan.totalBalancePaidDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.hireChallan.totalBalancePaidDate!)) : ""})",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.totalBalancePaid ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "total_balance".tr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.totalBalance ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              "labourAndParkingCharges".tr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.hireChallan.labourAndParkingCharges ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.015,
              ),
              Container(
                decoration: containerDecoration,
                width: screenWidth,
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "remarks".tr + " : ",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.015,
                    ),
                    Text(
                      " ${widget.hireChallan.remarks ?? ""}",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
