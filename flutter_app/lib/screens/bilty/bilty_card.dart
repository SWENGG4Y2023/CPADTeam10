import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_download_dialog.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_form.dart';
import 'package:transport_bilty_generator/screens/bilty/view_bilty_details.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';

import '../../services/backendAPI.dart';

class BiltyCard extends StatelessWidget {
  const BiltyCard({
    Key? key,
    required this.bilty,
    required this.textScaleFactor,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  final Bilty bilty;
  final double textScaleFactor;
  final double screenHeight;
  final double screenWidth;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 13),
      decoration: singleBorderedContainerDecoration,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BiltyDetails(bilty: bilty)),
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
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                child: Text(bilty.lrNumber!,
                    style: TextStyle(
                      fontSize: textScaleFactor * 14,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    "pickUp_date".tr + " : " +
                        DateFormat('dd-MM-yyyy').format(
                            DateTime.tryParse(bilty.pickupDate ?? "") ??
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
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
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
                    Text(
                      bilty.consigner != null ? bilty.consigner!.name : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${bilty.consignerAddress != null ? bilty.consignerAddress!.city : ""}, ${bilty.consignerAddress != null ? bilty.consignerAddress!.state : ""}",
                      style: TextStyle(fontSize: textScaleFactor * 12),
                    ),
                  ],
                ),
                SizedBox(
                  width: screenWidth * 0.07,
                ),
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
                    Text(
                      bilty.consignee != null ? bilty.consignee!.name : "",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: textScaleFactor * 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${bilty.consigneeAddress != null ? bilty.consigneeAddress!.city : ""}, ${bilty.consigneeAddress != null ? bilty.consigneeAddress!.state : ""}",
                      style: TextStyle(fontSize: textScaleFactor * 12),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Row(
              children: [
                Text(
                  bilty.invoiceNumber != null
                      ? "INV : " + bilty.invoiceNumber!
                      : "INV : ",
                  style: TextStyle(fontSize: textScaleFactor * 14),
                ),
                const Spacer(),
                Text(
                  bilty.invoiceValue != null
                      ? "₹ " + bilty.invoiceValue!
                      : "₹ ",
                  style: TextStyle(fontSize: textScaleFactor * 14),
                ),
              ],
            ),
            const Divider(),
            Container(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 18,
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Text(
                    bilty.driver != null ? bilty.driver!.name : "",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const FaIcon(
                    FontAwesomeIcons.car,
                    size: 14,
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  ),
                  Text(
                    bilty.vehicle != null ? bilty.vehicle!.vehicleNumber : "",
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  bilty.biltyType != null ? bilty.biltyType! : " ",
                  style: TextStyle(
                    fontSize: textScaleFactor * 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                    onPressed: () async {
                      BackendAPI backendAPI = BackendAPI();
                      if (kIsWeb) {
                        await backendAPI.downloadBiltyPDF(
                            bilty.id!, bilty.lrNumber!);
                      } else {
                        await showDialog(
                          context: context,
                          builder: (context) => BiltyDownloadDialog(
                            bilty: bilty,
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
                            builder: (context) => BiltyForm(
                                bilty: bilty, screenHeight: screenHeight)));
                    if (result == true) {
                      Navigator.popAndPushNamed(context, "/viewAllBilty");
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
                              titleText: bilty.lrNumber!,
                              deleteItem: "Bilty",
                              deleteObject: bilty,
                            ));
                    if (result == true) {
                      Navigator.popAndPushNamed(context, "/viewAllBilty");
                    }
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            Wrap(
              // mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "created_by".tr + " : ${bilty.createdBy?.name ?? ""}",
                  style: TextStyle(fontSize: textScaleFactor * 12),
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                ),
                SizedBox(
                  width: screenWidth * 0.02,
                ),
                Text(
                  bilty.createdTime != null
                      ? "date".tr + " " +
                          DateFormat('dd-MM-yyyy hh:mm a').format(
                              DateTime.parse(bilty.createdTime!).toLocal())
                      : "date".tr,
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
  }
}
