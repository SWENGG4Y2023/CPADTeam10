import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_form.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';
import 'package:transport_bilty_generator/widgets/snackbar.dart';

class InvoiceUpdateBiltyHireChallan extends StatefulWidget {
  final Invoice invoice;

  const InvoiceUpdateBiltyHireChallan({Key? key, required this.invoice})
      : super(key: key);

  @override
  State<InvoiceUpdateBiltyHireChallan> createState() =>
      _InvoiceUpdateBiltyHireChallanState();
}

class _InvoiceUpdateBiltyHireChallanState
    extends State<InvoiceUpdateBiltyHireChallan> {
  final BackendAPI backendAPI = BackendAPI();
  late Future<Map<String, dynamic>?> futureResources;

  final biltyMultiselectKey = GlobalKey<DropdownSearchState>();
  final biltySearchController = TextEditingController();

  final hireChallanMultiselectKey = GlobalKey<DropdownSearchState>();
  final hireChallanSearchController = TextEditingController();

  List<dynamic>? selectedBilty = [];
  List<dynamic>? selectedHireChallan = [];

  void prefillform(Invoice invoice) {
    if (invoice.listBilty != null && invoice.listBilty!.isNotEmpty) {
      selectedBilty = invoice.listBilty;
    }
    if (invoice.listHireChallan != null &&
        invoice.listHireChallan!.isNotEmpty) {
      // setState(() {
      //   hireChallanMultiselectKey.currentState!
      //       .changeSelectedItems(invoice.listHireChallan!);
      // });
      selectedHireChallan = invoice.listHireChallan;
    }
  }

  @override
  void initState() {
    futureResources = backendAPI
        .getAllBiltyAndHireChallanByCustomer(widget.invoice.customer!.id!);
    prefillform(widget.invoice);
    super.initState();
  }

  //loading boolean
  bool loading = false;

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
        return FutureBuilder<Map?>(
          future: futureResources,
          builder: (context, AsyncSnapshot<Map?> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Loading();
                break;
              case ConnectionState.done:
                if (snapshot.hasData) {
                  List<dynamic> listBilty = snapshot.data!['bilty'];
                  List<dynamic> listHireChallan = snapshot.data!['hireChallan'];
                  return AlertDialog(
                    insetPadding: const EdgeInsets.all(8),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.end,
                        //   children: [
                        //     IconButton(
                        //         onPressed: () {
                        //           prefillform(widget.invoice);
                        //         },
                        //         icon: Icon(Icons.refresh)),
                        //   ],
                        // ),
                        Text("Change Selected Bilty Or HireChallan",
                            style: TextStyle(fontSize: textScaleFactor * 16)),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              border: Border.all(color: kPrimaryColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: Text(
                              widget.invoice.invoiceNumber != null
                                  ? widget.invoice.invoiceNumber!
                                  : "",
                              style: TextStyle(
                                fontSize: textScaleFactor * 10,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // dropdown for bilty
                        widget.invoice.listBilty != null &&
                                widget.invoice.listBilty!.isNotEmpty
                            ? DropdownSearch<dynamic>.multiSelection(
                                key: biltyMultiselectKey,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      textInputDecoration.copyWith(
                                    labelText: "Bilty LrNumber".tr,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                ),
                                dropdownButtonProps: DropdownButtonProps(
                                  color: Colors.black,
                                ),
                                itemAsString: (bilty) => bilty.lrNumber,
                                items: listBilty,
                                popupProps:
                                    PopupPropsMultiSelection.modalBottomSheet(
                                        title: Container(
                                          decoration: containerDecoration,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8, horizontal: 20),
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  const Text("Add Bilty ?"),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () async {
                                                      var result = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  BiltyForm(
                                                                      bilty:
                                                                          null,
                                                                      screenHeight:
                                                                          screenHeight)));
                                                      if (result != false) {
                                                        setState(() {
                                                          biltyMultiselectKey
                                                              .currentState
                                                              ?.closeDropDownSearch();
                                                          futureResources = backendAPI
                                                              .getAllBiltyAndHireChallanByCustomer(
                                                                  widget
                                                                      .invoice
                                                                      .customer!
                                                                      .id!);
                                                        });
                                                      }
                                                    },
                                                    child: const Icon(Icons
                                                        .add_circle_outline_sharp),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                        modalBottomSheetProps:
                                            modalBottomSheetProps,
                                        showSearchBox: true,
                                        // disabledItemFn: (bilty) =>
                                        //     bilty.biltyType != "FREIGHT",
                                        itemBuilder:
                                            (context, item, isSelected) {
                                          return Container(
                                            decoration: containerDecoration,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 10),
                                            padding: const EdgeInsets.all(8),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.lrNumber,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          textScaleFactor * 16),
                                                ),
                                                Text(
                                                  item.consigner.name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor * 14),
                                                ),
                                                Text(
                                                  "${item.biltyType ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor * 14),
                                                ),
                                                Text(
                                                  "Freight : ${item.freight ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor * 14),
                                                ),
                                                Text(
                                                  "Total : ${item.totalAmount ?? ""}",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor * 14),
                                                ),
                                                // Text(
                                                //   item.pan,
                                                //   style: TextStyle(
                                                //       color: Colors.black,
                                                //       fontSize: textScaleFactor * 12),
                                                // ),
                                                // const Divider(),
                                              ],
                                            ),
                                          );
                                        },
                                        searchFieldProps: TextFieldProps(
                                          controller: biltySearchController,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText:
                                                "Search Bilty By LrNumber",
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                biltySearchController.clear();
                                              },
                                            ),
                                            border: const OutlineInputBorder(
                                              gapPadding: 4,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                        onItemAdded: (listSelected, bilty) {
                                          if (bilty.biltyType != "FREIGHT" ||
                                              bilty.freight == null ||
                                              bilty.totalAmount == null) {
                                            showDialog(
                                                context: context,
                                                builder: (BuildContext
                                                        context) =>
                                                    AlertDialog(
                                                      title: const Text(
                                                          "Bilty is unsuitable to create invoice"),
                                                      content: Text(
                                                        "Please Edit Bilty",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                textScaleFactor *
                                                                    14),
                                                      ),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context,
                                                                'Cancel');
                                                            biltyMultiselectKey
                                                                .currentState
                                                                ?.popupDeselectAllItems();
                                                          },
                                                          child: const Text(
                                                              "Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            Navigator.pop(
                                                                context);
                                                            var result = await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) => BiltyForm(
                                                                        bilty:
                                                                            bilty,
                                                                        screenHeight:
                                                                            screenHeight)));
                                                            if (result ==
                                                                true) {
                                                              biltyMultiselectKey
                                                                  .currentState
                                                                  ?.closeDropDownSearch();
                                                              setState(() {
                                                                futureResources =
                                                                    backendAPI.getAllBiltyAndHireChallanByCustomer(widget
                                                                        .invoice
                                                                        .customer!
                                                                        .id!);
                                                              });
                                                            }
                                                          },
                                                          child: const Text(
                                                              "Edit Bilty"),
                                                        )
                                                      ],
                                                    ));
                                          }
                                        }),
                                onChanged: (listSelected) {
                                  setState(() {
                                    selectedBilty = listSelected;
                                  });
                                },
                                onBeforeChange: (listBefore, listAfter) {
                                  bool biltyWithoutFreightExists = false;
                                  var listBeforeToSet = listBefore.toSet();
                                  var listAfterToSet = listAfter.toSet();
                                  var listNewItems = listAfterToSet
                                      .difference(listBeforeToSet);
                                  for (var bilty in listNewItems) {
                                    if (bilty.biltyType != "FREIGHT") {
                                      biltyWithoutFreightExists = true;
                                    }
                                  }
                                  if (biltyWithoutFreightExists) {
                                    return Future.value(false);
                                  } else {
                                    return Future.value(true);
                                  }
                                },
                              )
                            : SizedBox(),
                        SizedBox(
                          height: screenHeight * 0.015,
                        ),
                        // dropdown for hireChallan
                        widget.invoice.listHireChallan != null &&
                                widget.invoice.listHireChallan!.isNotEmpty
                            ? DropdownSearch<dynamic>.multiSelection(
                                selectedItems: selectedHireChallan!,
                                key: hireChallanMultiselectKey,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration:
                                      textInputDecoration.copyWith(
                                    labelText: "HireChallan Number".tr,
                                    labelStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: textScaleFactor * 14,
                                    ),
                                  ),
                                ),
                                compareFn: (i, s) {
                                  if (i.id == s.id) {
                                    return true;
                                  } else {
                                    return false;
                                  }
                                },
                                dropdownButtonProps: DropdownButtonProps(
                                  color: Colors.black,
                                ),
                                itemAsString: (hireChallan) =>
                                    hireChallan.hireChallanNumber,
                                items: listHireChallan,
                                popupProps:
                                    PopupPropsMultiSelection.modalBottomSheet(
                                  showSelectedItems: true,
                                  // disabledItemFn: (hireChallan) =>
                                  //     hireChallan.balanceType != "BALANCE",
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Text("Add HireChallan ?"),
                                            const Spacer(),
                                            InkWell(
                                              onTap: () async {
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const HireChallanForm(
                                                                  hireChallan:
                                                                      null,
                                                                )));
                                                if (result != false) {
                                                  setState(() {
                                                    hireChallanMultiselectKey
                                                        .currentState
                                                        ?.closeDropDownSearch();
                                                    futureResources = backendAPI
                                                        .getAllBiltyAndHireChallanByCustomer(
                                                            widget.invoice
                                                                .customer!.id!);
                                                  });
                                                }
                                              },
                                              child: const Icon(Icons
                                                  .add_circle_outline_sharp),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  modalBottomSheetProps: modalBottomSheetProps,
                                  showSearchBox: true,
                                  itemBuilder: (context, item, isSelected) {
                                    return Container(
                                      decoration: containerDecoration,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.hireChallanNumber,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textScaleFactor * 16),
                                          ),
                                          Text(
                                            item.transporter.name,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            "${item.balanceType ?? ""}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            "Total Freight : ${item.totalFreight ?? ""}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          // Text(
                                          //   item.pan,
                                          //   style: TextStyle(
                                          //       color: Colors.black,
                                          //       fontSize: textScaleFactor * 12),
                                          // ),
                                          // const Divider(),
                                        ],
                                      ),
                                    );
                                  },
                                  onItemAdded: (listSelected, hireChallan) {
                                    if ((hireChallan.balanceType !=
                                            "BALANCE") ||
                                        (hireChallan.totalFreight == null)) {
                                      //print(hireChallan.totalFreight);
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: const Text(
                                              "HireChallan is unsuitable to create invoice"),
                                          content: Text(
                                            "Please Edit HireChallan",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                                hireChallanMultiselectKey
                                                    .currentState
                                                    ?.popupDeselectAllItems();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (_) =>
                                                                HireChallanForm(
                                                                  hireChallan:
                                                                      hireChallan,
                                                                )));
                                                if (result != false) {
                                                  hireChallanMultiselectKey
                                                      .currentState
                                                      ?.closeDropDownSearch();
                                                  setState(() {
                                                    futureResources = backendAPI
                                                        .getAllBiltyAndHireChallanByCustomer(
                                                            widget.invoice
                                                                .customer!.id!);
                                                  });
                                                }
                                              },
                                              child: const Text(
                                                  "Edit HireChallan"),
                                            )
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                  searchFieldProps: TextFieldProps(
                                    controller: hireChallanSearchController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "Search HireChallan By Number",
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          hireChallanSearchController.clear();
                                        },
                                      ),
                                      border: const OutlineInputBorder(
                                        gapPadding: 4,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                onChanged: (list_selected) {
                                  setState(() {
                                    selectedHireChallan = list_selected;
                                  });
                                },
                              )
                            : const SizedBox(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context, false),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.black,
                                ),
                              ),
                              child: loading
                                  ? const SizedBox(
                                      width: 15,
                                      height: 15,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      "Update",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              onPressed: loading
                                  ? null
                                  : () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      //creating Invoice
                                      Invoice invoice = Invoice(
                                          listBilty: selectedBilty,
                                          listHireChallan: selectedHireChallan,
                                          id: widget.invoice.id,
                                          invoiceNumber: null,
                                          invoiceValue: null,
                                          suffixInvoiceNumber: null,
                                          createdBy: null,
                                          company: null,
                                          createdTime: null,
                                          customer: null,
                                          isTaxTypeIgst: null,
                                          gstPercentage: null,
                                          invoiceStatus: null,
                                          invoiceDate: null,
                                          sgst: null,
                                          igst: null,
                                          cgst: null,
                                          voucherNumber: null,
                                          otherChargesDescription: null,
                                          otherChargesAmount: null,
                                          isPaid: null,
                                          paidDate: null
                                      );
                                      var result = await backendAPI
                                          .addRemoveBiltyHireChallanToInvoice(
                                              invoice);
                                      if (result != false && result != null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(showSnackBar(
                                                "Invoice Updated Successfully"));
                                        Navigator.pop(context, true);
                                      } else {
                                        setState(() {
                                          loading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                                showSnackBar("Error Occurred"));
                                      }
                                    },
                            ),
                          ],
                        ),
                      ],
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
                              futureResources = backendAPI
                                  .getAllBiltyAndHireChallanByCustomer(
                                      widget.invoice.customer!.id!);
                            });
                          },
                          icon: const Icon(Icons.cached),
                        ),
                      ],
                    ),
                  );
                }
                break;
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
                              futureResources = backendAPI
                                  .getAllBiltyAndHireChallanByCustomer(
                                      widget.invoice.customer!.id!);
                            });
                          },
                          icon: const Icon(Icons.cached),
                        ),
                      ],
                    ),
                  );
                }
            }
          },
        );
      },
    );
  }
}
