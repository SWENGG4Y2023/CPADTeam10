import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/description.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_download_dialog.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_form.dart';
import 'package:transport_bilty_generator/screens/customer/view_customer_details.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/dashed_line.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';

class BiltyDetails extends StatefulWidget {
  final Bilty bilty;

  const BiltyDetails({Key? key, required this.bilty}) : super(key: key);

  @override
  State<BiltyDetails> createState() => _BiltyDetailsState();
}

class _BiltyDetailsState extends State<BiltyDetails> {
  final BackendAPI backendAPI = BackendAPI();
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "",
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
              SizedBox(
                height: screenHeight * 0.01,
              ),
              // lr number and date consigner consignee
              Container(
                padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.02,
                    vertical: screenHeight * 0.01),
                decoration: containerDecoration,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Text(widget.bilty.lrNumber!,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                        const Spacer(),
                        Text(
                            "pickUp_date".tr +
                                " : ${widget.bilty.pickupDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.bilty.pickupDate!)) : ""}",
                            style: TextStyle(
                              fontSize: textScaleFactor * 12,
                            )),
                      ],
                    ),
                    const Divider(),
                    // consigner consignee
                    Wrap(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "from".tr,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerCard(
                                            customer:
                                                widget.bilty.consigner!)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.bilty.consigner != null
                                        ? widget.bilty.consigner!.name
                                        : "",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  // Text(
                                  //   widget.bilty.consigner.email,
                                  //   style:
                                  //       TextStyle(fontSize: textScaleFactor * 10),
                                  // ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "pan_number".tr + ": ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textScaleFactor * 10,
                                        ),
                                      ),
                                      Text(
                                        widget.bilty.consigner != null
                                            ? widget.bilty.consigner!.pan
                                            : "",
                                        style: TextStyle(
                                          fontSize: textScaleFactor * 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "gst_number".tr + " : ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textScaleFactor * 10,
                                        ),
                                      ),
                                      Text(
                                        widget.bilty.consigner != null
                                            ? widget.bilty.consigner!.gstIn ??
                                                ""
                                            : "",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.005,
                            ),
                            Text(
                              widget.bilty.consignerAddress != null
                                  ? widget.bilty.consignerAddress!.address
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 12,
                              ),
                            ),
                            Text(
                              "${widget.bilty.consignerAddress != null ? widget.bilty.consignerAddress!.city : ""}, ${widget.bilty.consignerAddress != null ? widget.bilty.consignerAddress!.state : ""}",
                              style: TextStyle(
                                fontSize: textScaleFactor * 10,
                              ),
                            ),
                            Text(
                              widget.bilty.consignerAddress != null
                                  ? widget.bilty.consignerAddress!.zipCode
                                      .toString()
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 10,
                              ),
                            ),
                          ],
                        ),
                        // SizedBox(
                        //   width: screenWidth * 0.25,
                        // ),
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "to".tr,
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CustomerCard(
                                            customer:
                                                widget.bilty.consignee!)));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.bilty.consignee != null
                                        ? widget.bilty.consignee!.name
                                        : "",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // Text(
                                  //   widget.bilty.consignee.email,
                                  //   style:
                                  //       TextStyle(fontSize: textScaleFactor * 10),
                                  // ),
                                  SizedBox(
                                    height: screenHeight * 0.005,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "pan_number".tr + " : ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textScaleFactor * 10,
                                        ),
                                      ),
                                      Text(
                                        widget.bilty.consignee != null
                                            ? widget.bilty.consignee!.pan
                                            : "",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 10),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "gst_number".tr + " : ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: textScaleFactor * 10,
                                        ),
                                      ),
                                      Text(
                                        widget.bilty.consignee != null
                                            ? widget.bilty.consignee!.gstIn ??
                                                ""
                                            : "",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 10),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.005,
                            ),
                            Text(
                              widget.bilty.consigneeAddress != null
                                  ? widget.bilty.consigneeAddress!.address
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 12,
                              ),
                            ),
                            Text(
                              "${widget.bilty.consigneeAddress != null ? widget.bilty.consigneeAddress!.city : ""}, ${widget.bilty.consigneeAddress != null ? widget.bilty.consigneeAddress!.state : ""}",
                              style: TextStyle(
                                fontSize: textScaleFactor * 10,
                              ),
                            ),
                            Text(
                              widget.bilty.consigneeAddress != null
                                  ? widget.bilty.consigneeAddress!.zipCode
                                      .toString()
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 10,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              SizedBox(
                width: screenWidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //edit
                    OutlinedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BiltyForm(
                                    bilty: widget.bilty,
                                    screenHeight: screenHeight)));
                        if (result == true) {
                          Navigator.popAndPushNamed(context, "/viewAllBilty");
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
                    //delete
                    OutlinedButton(
                      onPressed: () async {
                        final result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => DeleteDialogBox(
                                  titleText: widget.bilty.lrNumber!,
                                  deleteItem: "Bilty",
                                  deleteObject: widget.bilty,
                                ));
                        if (result == true) {
                          Navigator.popAndPushNamed(context, "/viewAllBilty");
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
                    //download
                    OutlinedButton(
                        onPressed: () async {
                          if (kIsWeb) {
                            await backendAPI.downloadBiltyPDF(
                                widget.bilty.id!, widget.bilty.lrNumber!);
                          } else {
                            await showDialog(
                              context: context,
                              builder: (context) => BiltyDownloadDialog(
                                bilty: widget.bilty,
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
                height: screenHeight * 0.02,
              ),
              // description
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
                          "billing_details".tr,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        Text(
                          "insurance_number".tr +
                              " : ${widget.bilty.insuranceNumber != "" ? widget.bilty.insuranceNumber : ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "invoice_number".tr +
                              " : ${widget.bilty.invoiceNumber != "" ? widget.bilty.invoiceNumber : ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "invoice_value".tr +
                              " : ₹ ${widget.bilty.invoiceValue ?? ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "eway_billNumber".tr +
                              " : ${widget.bilty.ewayBillNumber != "" ? widget.bilty.ewayBillNumber : ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "ewayBill_date".tr +
                              " : ${widget.bilty.ewayBillDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.bilty.ewayBillDate!)) : ""}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Text(
                      "description".tr,
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Divider(),
                    widget.bilty.description != null
                        ? ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.bilty.description!.length,
                            itemBuilder: (BuildContext context, int i) {
                              Description description =
                                  widget.bilty.description![i];
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "item_name".tr + " : ${description.name}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "item_packets".tr +
                                        " : ${description.packet}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "item_type".tr + " : ${description.type}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    "item_weight".tr +
                                        " : ${description.weight}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            },
                          )
                        : const SizedBox(),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),

                    // driver and vechile
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
                                  widget.bilty.driver != null
                                      ? widget.bilty.driver!.name
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.bilty.driver != null
                                      ? widget.bilty.driver!.licenseNumber
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.bilty.driver != null
                                      ? widget.bilty.driver!.mobileNumber
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
                                  widget.bilty.vehicle != null
                                      ? widget.bilty.vehicle!.vehicleNumber
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  widget.bilty.vehicle != null
                                      ? widget.bilty.vehicle!.vehicleType
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
                    // recieving details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "receiver_details".tr,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        Text(
                          "billTo".tr + " : ${widget.bilty.billTo}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "reciever_name".tr +
                              " : ${widget.bilty.receiverName}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "receiver_contact".tr +
                              " : ${widget.bilty.receiverContact}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "remarks".tr + " : ${widget.bilty.remarks}",
                          style: const TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    //value details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "freight_details".tr,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        //freight
                        Row(
                          children: [
                            Text(
                              "freight".tr + " :",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            widget.bilty.isFreight == true
                                ? Text(
                                    "₹ ${widget.bilty.freight ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                : Text(
                                    "${widget.bilty.biltyType}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                          ],
                        ),
                        // builty charges
                        Row(
                          children: [
                            Text(
                              "bilty_charges".tr + " : ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "₹ ${widget.bilty.billtyCharges ?? ""}",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        //total amount
                        Row(
                          children: [
                            Text(
                              "total_amount".tr + " : ",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            widget.bilty.isFreight == true
                                ? Text(
                                    "₹ ${widget.bilty.totalAmount ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                : const Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                          ],
                        ),
                        //advance
                        Row(
                          children: [
                            Text(
                              "advance".tr + " :",
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            widget.bilty.isFreight == true
                                ? Text(
                                    "₹ ${widget.bilty.advance ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                : const Text(
                                    "",
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                          ],
                        ),
                        const MySeparator(),
                        SizedBox(
                          height: screenHeight * 0.003,
                        ),
                        Row(
                          children: [
                            Text(
                              "grandTotal".tr,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            widget.bilty.isFreight == true
                                ? Text(
                                    "₹ ${widget.bilty.grandTotal ?? ""}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                : Text(
                                    "${widget.bilty.biltyType}",
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
            ],
          ),
        ),
      ),
    );
  }
}
