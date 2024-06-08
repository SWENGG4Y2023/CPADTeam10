import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/screens/invoice/invoice_download_dialog.dart';
import 'package:transport_bilty_generator/screens/invoice/view_invoice_details.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final double textScaleFactor;
  final double screenHeight;
  final double screenWidth;

  const InvoiceCard({
    Key? key,
    required this.invoice,
    required this.textScaleFactor,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

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
                      builder: (_) => ViewInvoiceDetails(invoice: invoice)));
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                        invoice.invoiceNumber != null
                            ? invoice.invoiceNumber!
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
                            " : ${invoice.invoiceDate != null ? DateFormat('dd-MM-yyyy').format(DateTime.parse(invoice.invoiceDate!)) : ""}",
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
                          color: invoice.isPaid != null
                              ? invoice.isPaid!
                                  ? Colors.green
                                  : Colors.red
                              : Colors.black,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                        invoice.isPaid != null
                            ? invoice.isPaid!
                                ? "PAID"
                                : "UNPAID"
                            : "",
                        style: TextStyle(
                          fontSize: textScaleFactor * 14,
                          fontWeight: FontWeight.bold,
                          color: invoice.isPaid != null
                              ? invoice.isPaid!
                                  ? Colors.green
                                  : Colors.red
                              : Colors.black,
                        ),
                    ),
                  )
                ],
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                Column(
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
                      invoice.customer != null ? invoice.customer!.name : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      invoice.customer?.country ?? "",
                      style: TextStyle(
                        fontSize: textScaleFactor * 10,
                        // fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Row(
                  children: [
                    Text(
                      "invoice_value".tr + " : ",
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      invoice.invoiceValue != null
                          ? invoice.invoiceValue!.toString()
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
                    Text(
                      "invoice_status".tr + " - ${invoice.invoiceStatus ?? ""}",
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () async {
                        BackendAPI backendAPI = BackendAPI();
                        if (kIsWeb) {
                          await backendAPI.downloadInvoicePdf(
                              invoice.id!,
                              invoice.invoiceNumber!);
                        } else {
                          await showDialog(
                            context: context,
                            builder: (context) => InvoiceDownloadDialog(
                              invoice: invoice,
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.download),
                    ),
                  ],
                ),
                const Divider(),
                Wrap(
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "created_by".tr + " : ${invoice.createdBy?.name ?? ""}",
                      style: TextStyle(fontSize: textScaleFactor * 12),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    Text(
                      invoice.createdTime != null
                          ? "date".tr +
                              DateFormat(' dd-MM-yyyy hh:mm a').format(
                                  DateTime.parse(invoice.createdTime!)
                                      .toLocal())
                          : "date".tr,
                      style: TextStyle(fontSize: textScaleFactor * 12),
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),
                    SizedBox(
                      width: screenWidth * 0.02,
                    ),
                    if (invoice.isPaid != null && invoice.isPaid!)
                      Text(
                        invoice.paidDate != null
                            ? "invoice_paid_date".tr +
                                DateFormat(' dd-MM-yyyy').format(
                                    DateTime.parse(invoice.paidDate!)
                                        .toLocal())
                            : "",
                        style: TextStyle(fontSize: textScaleFactor * 12),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
