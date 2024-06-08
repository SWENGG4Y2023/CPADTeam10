import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/screens/customer/customer_form.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';

class CustomerCard extends StatefulWidget {
  final Customer customer;

  const CustomerCard({Key? key, required this.customer}) : super(key: key);

  @override
  State<CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<CustomerCard> {
  @override
  Widget build(BuildContext context) {
    //getting window size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    // Creating Address Text
    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return Scaffold(
          //backgroundColor: Colors.white,
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
              padding: EdgeInsets.only(
                  left: screenWidth * 0.03, right: screenWidth * 0.03),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Container(
                    // decoration: BoxDecoration(
                    //     color: kPrimaryColor,
                    //     borderRadius: BorderRadius.only(
                    //       bottomLeft: Radius.circular(20),
                    //       bottomRight: Radius.circular(20),
                    //     ),
                    //     boxShadow: [
                    //       BoxShadow(
                    //           // color: Colors.black,
                    //           offset: Offset(0, 0),
                    //           blurRadius: 4)
                    //     ]),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01),
                    child: Column(
                      children: [
                        Text(widget.customer.name,
                            style: TextStyle(
                              fontSize: textScaleFactor * 24,
                              fontWeight: FontWeight.w600,
                            )),
                        Text(
                          widget.customer.email,
                          style: TextStyle(
                            fontSize: textScaleFactor * 14,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.005,
                        ),
                        widget.customer.country == "INDIA"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "gst_number".tr + " : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                  Text(
                                    widget.customer.gstIn ?? "",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: screenHeight * 0.005,
                        ),
                        widget.customer.country == "INDIA"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "pan_number".tr + " : ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                  Text(
                                    widget.customer.pan,
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        SizedBox(
                          height: screenHeight * 0.009,
                        ),
                        Wrap(
                          children: [
                            // ...getPhonenumberTextWidgets(
                            //     widget.customer.phone, textScaleFactor),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.customer.phone.length,
                              itemBuilder: (BuildContext context, int i) {
                                List phoneNumbers = widget.customer.phone;
                                return Container(
                                  width: 50,
                                  padding: const EdgeInsets.all(1),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.32,
                                      vertical: 1),
                                  decoration: const BoxDecoration(
                                      color: Color.fromRGBO(38, 38, 38, 1),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: Center(
                                    child: Text(
                                      "${phoneNumbers[i]}",
                                      style: TextStyle(
                                          fontSize: textScaleFactor * 12,
                                          color: Colors.white),
                                    ),
                                  ),
                                );
                                // return Text(
                                //   phoneNumbers[i],
                                //   style: TextStyle(
                                //       backgroundColor: Colors.blue,
                                //       fontSize: textScaleFactor * 12,
                                //       color: Colors.black),
                                // );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: screenHeight * 0.01,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  var result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CustomerForm(
                                                customer: widget.customer,
                                                screenHeight: screenHeight,
                                              )));
                                  if (result == true) {
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  height: 30,
                                  width: 89,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black,
                                          offset: Offset(0, 0),
                                          blurRadius: 1)
                                    ],
                                    color: Colors.black,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    ),
                                  ),
                                  child: Text(
                                    "edit".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textScaleFactor * 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                            TextButton(
                                onPressed: () async {
                                  final result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DeleteDialogBox(
                                            titleText: widget.customer.name,
                                            deleteItem: "Customer",
                                            deleteObject: widget.customer,
                                          ));
                                  if (result == true) {
                                    Navigator.of(context).pop(true);
                                  }
                                },
                                child: Container(
                                  height: 30,
                                  width: 89,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.red,
                                          offset: Offset(0, 0),
                                          blurRadius: 1)
                                    ],
                                  ),
                                  child: Text(
                                    "delete".tr,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: textScaleFactor * 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  Container(
                    width: screenWidth,
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("  " + "address".tr,
                                style: TextStyle(
                                  fontSize: textScaleFactor * 14,
                                  fontWeight: FontWeight.bold,
                                )),
                            Spacer(),
                            widget.customer.country != null
                                ? Container(
                                    padding: const EdgeInsets.all(5),
                                    decoration:
                                        redOutlineContainerDecoration.copyWith(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                    child: Text(
                                      "COUNTRY : ${widget.customer.country}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        // ...getAddressTextWidgets(widget.customer.address,
                        //     screenHeight, textScaleFactor, screenWidth)
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.customer.address.length,
                          itemBuilder: (BuildContext context, int i) {
                            List addressList = widget.customer.address;
                            return Container(
                              decoration:
                                  containerDecoration.copyWith(boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 3,
                                )
                              ]),
                              width: screenWidth,
                              margin: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.004),
                              padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.03,
                                  vertical: screenHeight * 0.01),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${addressList[i].address},",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.002,
                                  ),
                                  Text(
                                    "${addressList[i].city},",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.002,
                                  ),
                                  Text(
                                    "${addressList[i].state},",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.002,
                                  ),
                                  Text(
                                    "${addressList[i].zipCode}",
                                    style: TextStyle(
                                      fontSize: textScaleFactor * 16,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.002,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
