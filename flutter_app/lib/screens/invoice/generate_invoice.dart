import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_form.dart';
import 'package:transport_bilty_generator/screens/customer/customer_form.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_form.dart';
import 'package:transport_bilty_generator/screens/invoice/view_invoice_details.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';
// import 'package:transport_bilty_generator/widgets/snackbar.dart';

class GenerateInvoice extends StatefulWidget {
  const GenerateInvoice({Key? key}) : super(key: key);

  @override
  State<GenerateInvoice> createState() => _GenerateInvoiceState();
}

class _GenerateInvoiceState extends State<GenerateInvoice> {
  late Future<Map<String, dynamic>?> futureResources;
  final BackendAPI backendAPI = BackendAPI();

  // form Global Key
  final _formKey = GlobalKey<FormState>();
  final biltyMultiselectKey = GlobalKey<DropdownSearchState>();
  final biltySearchController = TextEditingController();

  final hireChallanMultiselectKey = GlobalKey<DropdownSearchState>();
  final hireChallanSearchController = TextEditingController();

  final consignerDropdownKey = GlobalKey<DropdownSearchState>();
  final consignerSearchController = TextEditingController();
  List<dynamic>? selectedBilty;
  List<dynamic>? selectedHireChallan;
  var consigner;
  bool hasFilterNotRan = true;

  bool? isTaxTypeIgst;

  double? gstPercentage;
  String? invoiceStatus;
  String? taxType;
  String? voucherNumber;
  String? otherChargesDescription;
  double? otherChargesAmount;

  // startDate and endDate
  //Date
  DateTime? startDate;

  // function for getting date and time
  Future<void> _startDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  // balanceDate
  DateTime? endDate;

  // function for getting date and time
  Future<void> _endDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  DateTime? invoiceDate;

  // function for getting date and time
  Future<void> _invoiceDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: invoiceDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != invoiceDate) {
      setState(() {
        invoiceDate = picked;
      });
    }
  }

  @override
  void initState() {
    futureResources = backendAPI.getAllBiltyAndHireChallan();
    super.initState();
  }

  //loading boolean
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;

    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "generate_invoice".tr,
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
          body: FutureBuilder<Map?>(
            future: futureResources,
            builder: (context, AsyncSnapshot<Map?> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    List<dynamic> listBilty = snapshot.data!['bilty'];
                    List<dynamic> listHireChallan =
                        snapshot.data!['hireChallan'];
                    List<dynamic> listCustomers = snapshot.data!['customers'];
                    var user = snapshot.data!['user'];
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              // container for filter
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.5)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "start".tr,
                                          style: TextStyle(
                                              fontSize: textScaleFactor * 16),
                                        ),
                                        IconButton(
                                          // style: ButtonStyle(
                                          //   backgroundColor:
                                          //       MaterialStateProperty.all(
                                          //     Colors.black,
                                          //   ),
                                          // ),
                                          onPressed: () async =>
                                              _startDateSelector(context),
                                          icon: Icon(Icons.date_range),
                                        ),
                                        Spacer(),
                                        Text(
                                          startDate != null
                                              ? DateFormat('dd-MM-yyyy')
                                                  .format(startDate!)
                                              : "dd-MM-yyyy",
                                          style: TextStyle(
                                            fontSize: textScaleFactor * 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "end".tr,
                                          style: TextStyle(
                                              fontSize: textScaleFactor * 16),
                                        ),
                                        IconButton(
                                          // style: ButtonStyle(
                                          //   backgroundColor:
                                          //       MaterialStateProperty.all(
                                          //     Colors.black,
                                          //   ),
                                          // ),
                                          onPressed: () async =>
                                              _endDateSelector(context),
                                          icon: Icon(Icons.date_range),
                                        ),
                                        Spacer(),
                                        Text(
                                          endDate != null
                                              ? DateFormat('dd-MM-yyyy')
                                                  .format(endDate!)
                                              : "dd-MM-yyyy",
                                          style: TextStyle(
                                            fontSize: textScaleFactor * 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // customer Search
                                    DropdownSearch<dynamic>(
                                      // dropdownDecoratorProps:
                                      //     DropDownDecoratorProps(
                                      //         dropdownSearchDecoration:
                                      //             textInputDecoration.copyWith(
                                      //                 labelText:
                                      //                     "consigner_name".tr)),
                                      clearButtonProps: ClearButtonProps(
                                        isVisible: true,
                                      ),
                                      dropdownDecoratorProps:
                                          DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                        border: InputBorder.none,
                                        labelText: "consigner_name".tr,
                                      )),
                                      selectedItem: consigner,
                                      key: consignerDropdownKey,
                                      items: listCustomers,
                                      itemAsString: (customer) => customer.name,
                                      popupProps: PopupProps.modalBottomSheet(
                                        title: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14, vertical: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Text("add_consigner".tr),
                                                  const Spacer(),
                                                  InkWell(
                                                    onTap: () async {
                                                      var result = await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  CustomerForm(
                                                                      customer:
                                                                          null,
                                                                      screenHeight:
                                                                          screenHeight)));
                                                      if (result == true) {
                                                        setState(() {
                                                          consignerDropdownKey
                                                              .currentState
                                                              ?.closeDropDownSearch();
                                                          futureResources =
                                                              backendAPI
                                                                  .getAllBiltyAndHireChallan();
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
                                        itemBuilder:
                                            (context, item, isSelected) {
                                          return Container(
                                            decoration: containerDecoration,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 20),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  item.name,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                ),
                                                Text(
                                                  item.gstIn,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          textScaleFactor * 12),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      item.pan,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize:
                                                              textScaleFactor *
                                                                  12),
                                                    ),
                                                    Spacer(),
                                                    item.country != null
                                                        ? Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(5),
                                                            decoration: redOutlineContainerDecoration.copyWith(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8)),
                                                            child: Text(
                                                              "${item.country}",
                                                              style:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                          )
                                                        : const SizedBox(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        searchFieldProps: TextFieldProps(
                                          controller: consignerSearchController,
                                          style: const TextStyle(
                                              color: Colors.black),
                                          decoration: InputDecoration(
                                            hintText:
                                                "search_consigner_by_name".tr,
                                            suffixIcon: IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                consignerSearchController
                                                    .clear();
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
                                      onChanged: (val) async {
                                        // using the searchCustomer method here to get the customer details
                                        // and forwarding to the customer Page
                                        // var customer =
                                        //     await backendAPI.getCustomerBySearch(val);
                                        // setState(() {
                                        //   consigner = customer[0];
                                        //   consignerAddressList = customer[0].address;
                                        // });
                                        setState(() {
                                          consigner = val;
                                        });
                                      },
                                    ),
                                    Divider(
                                      height: 0,
                                    ),
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        // minimumSize: MaterialStateProperty.all(
                                        //     const Size(50, 40)),
                                        // maximumSize: MaterialStateProperty.all(
                                        //     const Size(120, 40)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          Colors.white,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("filter".tr),
                                          Icon(Icons.filter_alt),
                                        ],
                                      ),
                                      onPressed: () {
                                        if (consigner != null &&
                                            startDate != null &&
                                            endDate != null) {
                                          setState(() {
                                            futureResources = backendAPI
                                                .filterBiltyHireChallanForInvoice(
                                                    consigner.id,
                                                    convertDateTimeToString(
                                                        startDate!)!,
                                                    convertDateTimeToString(
                                                        endDate!)!);
                                            hasFilterNotRan = false;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              const Divider(),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // Bilty Dropdown
                              IgnorePointer(
                                ignoring: hasFilterNotRan,
                                child: DropdownSearch<dynamic>.multiSelection(
                                  key: biltyMultiselectKey,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                      labelText: "bilty_lrNumber".tr,
                                      labelStyle: TextStyle(
                                        color: hasFilterNotRan
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black,
                                        fontSize: textScaleFactor * 14,
                                      ),
                                    ),
                                  ),
                                  dropdownButtonProps: DropdownButtonProps(
                                    color: hasFilterNotRan
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.black,
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
                                                    Text("add_bilty".tr),
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
                                                            futureResources = backendAPI.filterBiltyHireChallanForInvoice(
                                                                consigner.id!,
                                                                convertDateTimeToString(
                                                                    startDate!)!,
                                                                convertDateTimeToString(
                                                                    endDate!)!);
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
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
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
                                                            textScaleFactor *
                                                                16),
                                                  ),
                                                  Text(
                                                    item.consigner.name,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            textScaleFactor *
                                                                14),
                                                  ),
                                                  Text(
                                                    "${item.biltyType ?? ""}",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            textScaleFactor *
                                                                14),
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
                                                  "search_bilty_by_lrNumber".tr,
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
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: Text(
                                                                "bilty_type_is_not_freight"
                                                                    .tr),
                                                            content: Text(
                                                                "please_edit_bilty"
                                                                    .tr),
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
                                                                child: Text(
                                                                    "cancel"
                                                                        .tr),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  Navigator.pop(
                                                                      context);
                                                                  var result = await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (_) => BiltyForm(
                                                                              bilty: bilty,
                                                                              screenHeight: screenHeight)));
                                                                  if (result ==
                                                                      true) {
                                                                    biltyMultiselectKey
                                                                        .currentState
                                                                        ?.closeDropDownSearch();
                                                                    setState(
                                                                        () {
                                                                      futureResources = backendAPI.filterBiltyHireChallanForInvoice(
                                                                          consigner
                                                                              .id!,
                                                                          convertDateTimeToString(
                                                                              startDate!)!,
                                                                          convertDateTimeToString(
                                                                              endDate!)!);
                                                                    });
                                                                  }
                                                                },
                                                                child: Text(
                                                                    "edit_bilty"
                                                                        .tr),
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
                                ),
                              ),
                              // bilty multiSelect
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              //hireChallan MultiSelect
                              IgnorePointer(
                                ignoring: hasFilterNotRan,
                                child: DropdownSearch<dynamic>.multiSelection(
                                  key: hireChallanMultiselectKey,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                      labelText: "hireChallan_number".tr,
                                      labelStyle: TextStyle(
                                        color: hasFilterNotRan
                                            ? Colors.black.withOpacity(0.4)
                                            : Colors.black,
                                        fontSize: textScaleFactor * 14,
                                      ),
                                    ),
                                  ),
                                  dropdownButtonProps: DropdownButtonProps(
                                    color: hasFilterNotRan
                                        ? Colors.black.withOpacity(0.2)
                                        : Colors.black,
                                  ),
                                  itemAsString: (hireChallan) =>
                                      hireChallan.hireChallanNumber,
                                  items: listHireChallan,
                                  popupProps:
                                      PopupPropsMultiSelection.modalBottomSheet(
                                    // disabledItemFn: (hireChallan) =>
                                    //     hireChallan.balanceType != "BALANCE",
                                    title: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("add_hireChallan".tr + " ?"),
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
                                                          .filterBiltyHireChallanForInvoice(
                                                              consigner.id!,
                                                              convertDateTimeToString(
                                                                  startDate!)!,
                                                              convertDateTimeToString(
                                                                  endDate!)!);
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
                                                  fontSize:
                                                      textScaleFactor * 16),
                                            ),
                                            Text(
                                              item.transporter.name,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      textScaleFactor * 14),
                                            ),
                                            Text(
                                              "${item.balanceType ?? ""}",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      textScaleFactor * 14),
                                            ),
                                            Text(
                                              "total_freight".tr +
                                                  " : ${item.totalFreight ?? ""}",
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
                                    onItemAdded: (listSelected, hireChallan) {
                                      if ((hireChallan.balanceType !=
                                              "BALANCE") ||
                                          (hireChallan.totalFreight == null)) {
                                        //print(hireChallan.totalFreight);
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              AlertDialog(
                                            title: Text(
                                                "hireChallan_is_unsuitable_to_create_invoice"
                                                    .tr),
                                            content: Text(
                                              "please_edit_hireChallan".tr,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      textScaleFactor * 14),
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
                                                child: Text("cancel".tr),
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
                                                          .filterBiltyHireChallanForInvoice(
                                                              consigner.id!,
                                                              convertDateTimeToString(
                                                                  startDate!)!,
                                                              convertDateTimeToString(
                                                                  endDate!)!);
                                                    });
                                                  }
                                                },
                                                child: Text("edit".tr),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                    },
                                    searchFieldProps: TextFieldProps(
                                      controller: hireChallanSearchController,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        hintText:
                                            "search_hireChallan_by_number".tr,
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
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.02,
                              ),
                              RadioListTile(
                                title: const Text(
                                  "IGST",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                value: "IGST",
                                groupValue: taxType,
                                onChanged: (value) {
                                  setState(() {
                                    taxType = value.toString();
                                    isTaxTypeIgst = true;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              ),
                              RadioListTile(
                                title: const Text(
                                  "SGST/CGST",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                value: "SGST/CGST",
                                groupValue: taxType,
                                onChanged: (value) {
                                  setState(() {
                                    taxType = value.toString();
                                    isTaxTypeIgst = false;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "gst_percentage".tr),
                                initialValue: gstPercentage != null
                                    ? gstPercentage.toString()
                                    : '',
                                onChanged: (val) {
                                  if (val != "") {
                                    setState(() {
                                      gstPercentage = double.parse(val);
                                    });
                                  } else {
                                    setState(() {
                                      gstPercentage = null;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "voucher_number".tr),
                                initialValue: voucherNumber,
                                onChanged: (val) {
                                  setState(() {
                                    voucherNumber = val;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "invoice_status".tr),
                                initialValue: invoiceStatus,
                                onChanged: (val) {
                                  setState(() {
                                    invoiceStatus = val;
                                  });
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "other_charges_description".tr),
                                initialValue: otherChargesDescription != null
                                    ? otherChargesDescription.toString()
                                    : '',
                                onChanged: (val) {
                                  if (val != "") {
                                    setState(() {
                                      otherChargesDescription = val;
                                    });
                                  } else {
                                    setState(() {
                                      otherChargesDescription = null;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.text,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "other_charges_amount".tr),
                                initialValue: otherChargesAmount != null
                                    ? otherChargesAmount.toString()
                                    : '',
                                onChanged: (val) {
                                  if (val != "") {
                                    setState(() {
                                      otherChargesAmount = double.parse(val);
                                    });
                                  } else {
                                    setState(() {
                                      otherChargesAmount = null;
                                    });
                                  }
                                },
                                keyboardType: TextInputType.number,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.5)),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "date".tr,
                                      style: TextStyle(
                                          fontSize: textScaleFactor * 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(invoiceDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(invoiceDate!)
                                            : ""),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.white,
                                            ),
                                          ),
                                          onPressed: () async =>
                                              _invoiceDateSelector(context),
                                          child: Text('select_date'.tr),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(double.infinity, 50)),
                                  backgroundColor: MaterialStateProperty.all(
                                    Colors.black,
                                  ),
                                ),
                                child: _loading
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
                                    : Text(
                                        "generate".tr,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                onPressed: _loading
                                    ? null
                                    : () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            _loading = true;
                                          });
                                          Invoice invoice = Invoice(
                                            listBilty: selectedBilty,
                                            listHireChallan:
                                                selectedHireChallan,
                                            id: null,
                                            invoiceNumber: null,
                                            invoiceValue: null,
                                            suffixInvoiceNumber: null,
                                            createdBy: null,
                                            company: user.company,
                                            createdTime: null,
                                            customer: consigner,
                                            isTaxTypeIgst: isTaxTypeIgst,
                                            gstPercentage: gstPercentage,
                                            invoiceStatus: invoiceStatus,
                                            voucherNumber: voucherNumber,
                                            invoiceDate: invoiceDate != null
                                                ? DateFormat(
                                                            "yyyy-MM-ddTHH:mm:ss.ms")
                                                        .format(invoiceDate!) +
                                                    "Z"
                                                : null,
                                            sgst: null,
                                            igst: null,
                                            cgst: null,
                                            otherChargesDescription:
                                                otherChargesDescription,
                                            otherChargesAmount:
                                                otherChargesAmount,
                                            isPaid: false,
                                            paidDate: null,
                                          );
                                          // creating invoice object
                                          var result = await backendAPI
                                              .generateInvoice(invoice);
                                          if (result != false &&
                                              result != null) {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    ViewInvoiceDetails(
                                                        invoice: result),
                                              ),
                                            );
                                            Get.snackbar(
                                              "success".tr,
                                              "success_message".tr,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white,
                                            );
                                          } else {
                                            setState(() {
                                              _loading = false;
                                            });
                                            Get.snackbar(
                                              "error".tr,
                                              "error_message".tr,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white,
                                            );
                                          }
                                        }
                                      },
                              ),
                              SizedBox(
                                height: screenHeight * 0.1,
                              ),
                            ],
                          ),
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
                                futureResources =
                                    backendAPI.getAllBiltyAndHireChallan();
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
                                futureResources =
                                    backendAPI.getAllBiltyAndHireChallan();
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
          ),
        );
      },
    );
  }
}
