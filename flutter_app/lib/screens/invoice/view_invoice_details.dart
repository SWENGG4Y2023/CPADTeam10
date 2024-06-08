import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_card.dart';
import 'package:transport_bilty_generator/screens/bilty/view_bilty_details.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_card.dart';
import 'package:transport_bilty_generator/screens/hireChallan/view_challan_details.dart';
import 'package:transport_bilty_generator/screens/invoice/invoice_download_dialog.dart';
import 'package:transport_bilty_generator/screens/invoice/update_invoice.dart';
import 'package:transport_bilty_generator/screens/invoice/widgets/invoice_updateBiltyHireChallan.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';

class ViewInvoiceDetails extends StatefulWidget {
  Invoice invoice;

  ViewInvoiceDetails({Key? key, required this.invoice}) : super(key: key);

  @override
  State<ViewInvoiceDetails> createState() => _ViewInvoiceDetailsState();
}

class _ViewInvoiceDetailsState extends State<ViewInvoiceDetails> {
  @override
  Widget build(BuildContext context) {
    final BackendAPI backendAPI = BackendAPI();
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "invoice_details".tr,
          style: const TextStyle(
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
              vertical: screenHeight * 0.01, horizontal: screenWidth * 0.015),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: containerDecoration,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            child: Text(
                                widget.invoice.invoiceNumber != null
                                    ? widget.invoice.invoiceNumber!
                                    : "",
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
                                    " : ${widget.invoice.invoiceDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(widget.invoice.invoiceDate!)) : ""}",
                                style: TextStyle(
                                  fontSize: textScaleFactor * 11,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: widget.invoice.isPaid != null
                                      ? widget.invoice.isPaid!
                                      ? Colors.green
                                      : Colors.red
                                      : Colors.black,
                                ),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                            child: Text(
                              widget.invoice.isPaid != null
                                  ? widget.invoice.isPaid!
                                  ? "PAID"
                                  : "UNPAID"
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                                fontWeight: FontWeight.bold,
                                color: widget.invoice.isPaid != null
                                    ? widget.invoice.isPaid!
                                    ? Colors.green
                                    : Colors.red
                                    : Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              // add onTap function here to go to customer details
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "customer".tr + " : ",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.invoice.customer != null
                                        ? widget.invoice.customer!.name
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.invoice.customer != null
                                        ? widget.invoice.customer!.country ?? ""
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 12,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    widget.invoice.customer != null
                                        ? widget.invoice.customer!.gstIn ?? ""
                                        : "",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 12,
                                      // fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        Text(
                          "gst".tr +
                              ' %' +
                              " ${widget.invoice.isTaxTypeIgst != null ? widget.invoice.isTaxTypeIgst == true ? "IGST" : "SGST/CGST" : ""}",
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${widget.invoice.gstPercentage != null ? widget.invoice.gstPercentage!.toString() : ""}%",
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                          ),
                        ),
                      ],
                    ),
                    widget.invoice.isTaxTypeIgst != null
                        ? widget.invoice.isTaxTypeIgst == true
                            ? Row(
                                children: [
                                  Text(
                                    "gst_amount".tr + "(IGST) : ",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.invoice.igst != null
                                        ? widget.invoice.igst!.toString()
                                        : "",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "gst_amount".tr + "(SGST) : ",
                                        style: TextStyle(
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.invoice.sgst != null
                                            ? widget.invoice.sgst!.toString()
                                            : "",
                                        style: TextStyle(
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "gst_amount".tr + "(CGST) : ",
                                        style: TextStyle(
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        widget.invoice.cgst != null
                                            ? widget.invoice.cgst!.toString()
                                            : "",
                                        style: TextStyle(
                                          fontSize: textScaleFactor * 14,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                        : const SizedBox(),
                    Row(
                      children: [
                        Text(
                          "total_invoice_value".tr + " : ",
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          widget.invoice.invoiceValue != null
                              ? widget.invoice.invoiceValue!.toString()
                              : "",
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "voucher_number".tr +
                                  " ${widget.invoice.voucherNumber != null ? widget.invoice.voucherNumber!.toString() : ""}",
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                              ),
                            ),
                            Text(
                              "invoice_status".tr +
                                  " ${widget.invoice.invoiceStatus ?? ""}",
                              style: TextStyle(
                                fontSize: textScaleFactor * 14,
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.02,
                            ),
                            if (widget.invoice.isPaid != null && widget.invoice.isPaid!)
                              Text(
                                widget.invoice.paidDate != null
                                    ? "invoice_paid_date".tr +
                                    DateFormat(' dd-MM-yyyy').format(
                                        DateTime.parse(widget.invoice.paidDate!)
                                            .toLocal())
                                    : "",
                                style: TextStyle(fontSize: textScaleFactor * 14),
                                overflow: TextOverflow.ellipsis,
                                softWrap: true,
                              ),
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () async {
                                if (kIsWeb) {
                                  await backendAPI.downloadInvoicePdf(
                                      widget.invoice.id!,
                                      widget.invoice.invoiceNumber!);
                                } else {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => InvoiceDownloadDialog(
                                      invoice: widget.invoice,
                                    ),
                                  );
                                }
                              },
                              icon: const Icon(Icons.download),
                            ),
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                // push to edit invoice screen with invoice data and update invoice data
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateInvoice(
                                      invoice: widget.invoice,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              widget.invoice.listBilty != null &&
                      widget.invoice.listBilty!.isNotEmpty
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "list_bilty".tr + " :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: textScaleFactor * 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          style: ButtonStyle(
                            side: MaterialStateProperty.all(
                              const BorderSide(width: 1, color: Colors.black),
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  InvoiceUpdateBiltyHireChallan(
                                      invoice: widget.invoice),
                            );
                            if (result == true) {
                              Invoice updatedInvoice = await backendAPI
                                  .getInvoiceById(widget.invoice.id!);
                              setState(() {
                                widget.invoice = updatedInvoice;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.invoice.listBilty != null &&
                      widget.invoice.listBilty!.isNotEmpty
                  ? SizedBox(
                      height: screenHeight * 0.01,
                    )
                  : const SizedBox(),
              // SizedBox(
              //   height: screenHeight * 0.01,
              // ),
              widget.invoice.listBilty != null
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.invoice.listBilty!.length,
                      itemBuilder: (BuildContext context, int i) {
                        Bilty bilty = widget.invoice.listBilty![i];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BiltyDetails(bilty: bilty),
                              ),
                            );
                          },
                          child: BiltyCard(
                            bilty: bilty,
                            screenHeight: screenHeight,
                            textScaleFactor: textScaleFactor,
                            screenWidth: screenWidth,
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
              widget.invoice.listHireChallan != null &&
                      widget.invoice.listHireChallan!.isNotEmpty
                  ? Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "list_hireChallan".tr + " :",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: textScaleFactor * 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(
                            Icons.edit,
                          ),
                          onPressed: () async {
                            var result = await showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  InvoiceUpdateBiltyHireChallan(
                                invoice: widget.invoice,
                              ),
                            );
                            if (result == true) {
                              Invoice updatedInvoice = await backendAPI
                                  .getInvoiceById(widget.invoice.id!);
                              setState(() {
                                widget.invoice = updatedInvoice;
                              });
                            }
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              widget.invoice.listHireChallan != null &&
                      widget.invoice.listHireChallan!.isNotEmpty
                  ? SizedBox(
                      height: screenHeight * 0.01,
                    )
                  : const SizedBox(),
              widget.invoice.listHireChallan != null
                  ? ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.invoice.listHireChallan!.length,
                      itemBuilder: (BuildContext context, int i) {
                        HireChallan hireChallan =
                            widget.invoice.listHireChallan![i];
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => HireChallanDetails(
                                  hireChallan: hireChallan,
                                ),
                              ),
                            );
                          },
                          child: HireChallanCard(
                            hireChallan: hireChallan,
                            screenHeight: screenHeight,
                            textScaleFactor: textScaleFactor,
                            screenWidth: screenWidth,
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
