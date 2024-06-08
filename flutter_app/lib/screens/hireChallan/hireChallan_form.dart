import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/screens/customer/customer_form.dart';
import 'package:transport_bilty_generator/screens/driver/driver_form.dart';
import 'package:transport_bilty_generator/screens/hireChallan/view_challan_details.dart';
import 'package:transport_bilty_generator/screens/vehicle/vehicle_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';
import 'package:transport_bilty_generator/widgets/snackbar.dart';

class HireChallanForm extends StatefulWidget {
  final HireChallan? hireChallan;

  const HireChallanForm({Key? key, required this.hireChallan})
      : super(key: key);

  @override
  State<HireChallanForm> createState() => _HireChallanFormState();
}

class _HireChallanFormState extends State<HireChallanForm> {
  final BackendAPI backendAPI = BackendAPI();
  late Future<Map<String, dynamic>?> futureResources;

  //Date
  DateTime? advanceInBankDate;

  // function for getting date and time
  Future<void> _advanceInBankDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: advanceInBankDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != advanceInBankDate) {
      setState(() {
        advanceInBankDate = picked;
      });
    }
  }

  // balanceDate
  DateTime? balanceDate;

  // function for getting date and time
  Future<void> _balanceDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: balanceDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != balanceDate) {
      setState(() {
        balanceDate = picked;
      });
    }
  }

  // loadingDate
  DateTime? loadingDate;

  // function for getting date and time
  Future<void> _loadingDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: balanceDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != balanceDate) {
      setState(() {
        loadingDate = picked;
      });
    }
  }

  // balanceDate
  DateTime? unloadingDate;

  // function for getting date and time
  Future<void> _unloadingDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: balanceDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != balanceDate) {
      setState(() {
        unloadingDate = picked;
      });
    }
  }

  DateTime? totalFreightDate;

  // function for getting date and time
  Future<void> _totalFreightDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: totalFreightDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != totalFreightDate) {
      setState(() {
        totalFreightDate = picked;
      });
    }
  }

  DateTime? advanceInCashDate;

  // function for getting date and time
  Future<void> _advanceInCashDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        // builder: (context, child) {
        //   return Theme(
        //     data: ThemeData.light().copyWith(
        //       colorScheme: const ColorScheme(
        //         primary: kPrimaryColor,
        //         secondary: kPrimaryColor,
        //         surface: kPrimaryColor,
        //         background: kPrimaryColor,
        //         error: kPrimaryColor,
        //         onPrimary: Colors.black,
        //         onSecondary: Colors.black,
        //         onSurface: Colors.black,
        //         onBackground: Colors.black,
        //         onError: Colors.black,
        //         brightness: Brightness.light,
        //       ),
        //       dialogBackgroundColor: Colors.white,
        //     ),
        //     child: child!,
        //   );
        // },
        context: context,
        initialDate: advanceInCashDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != advanceInCashDate) {
      setState(() {
        advanceInCashDate = picked;
      });
    }
  }

  DateTime? totalBalancePaidDate;

  // function for getting date and time
  Future<void> _totalBalanceDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: totalBalancePaidDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != totalBalancePaidDate) {
      setState(() {
        totalBalancePaidDate = picked;
      });
    }
  }

  DateTime? driveAdvanceCashbyPartyDate;

  // function for getting date and time
  Future<void> _driveAdvanceCashbyPartyDateSelector(
      BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: driveAdvanceCashbyPartyDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != driveAdvanceCashbyPartyDate) {
      setState(() {
        driveAdvanceCashbyPartyDate = picked;
      });
    }
  }

  var transporter;
  var vehicle;
  var driver;
  int? advanceInBank;
  int? advanceInCash;
  int? balance;
  String? balanceType = "BALANCE";

  // double? cgst;
  int? driveAdvanceCashbyParty;
  String? fromSource;

  //double? gstPercentage;

  //double? igst;
  bool isBalance = true;

  // bool? isTaxTypeIgst = false;
  // String? gstType;
  String? personDesignation;
  String? personName;
  String? personNumber;
  String? rate;
  String? remarks;

  // double? sgst;
  int? tds;
  String? toDestination;
  int? totalAdvance;
  int? totalAdvanceDate;
  int? totalBalance;
  int? totalBalancePaid;
  int? totalDeduction;
  int? totalFreight;
  int? totalFreightWithTax;
  String? weight;
  int? labourAndParkingCharges;

  void prefillForm(HireChallan? hireChallan) {
    if (hireChallan != null) {
      transporter = hireChallan.transporter;
      driver = hireChallan.driver;
      vehicle = hireChallan.vehicle;
      advanceInBank = hireChallan.advanceInBank;
      advanceInCash = hireChallan.advanceInCash;
      // balance = hireChallan.balance;
      // cgst = hireChallan.cgst;
      // igst = hireChallan.igst;
      // sgst = hireChallan.sgst;
      //isTaxTypeIgst = hireChallan.isTaxTypeIGST;
      // gstType = hireChallan.isTaxTypeIGST != null
      //     ? hireChallan.isTaxTypeIGST == true
      //         ? "IGST"
      //         : "SGST"
      //     : null;
      //gstPercentage = hireChallan.gstPercentage;
      balanceType = hireChallan.balanceType;
      isBalance = hireChallan.isBalance;
      personName = hireChallan.personName;
      personDesignation = hireChallan.personDesignation;
      personNumber = hireChallan.personNumber;
      rate = hireChallan.rate;
      remarks = hireChallan.remarks;
      tds = hireChallan.tds;
      fromSource = hireChallan.fromSource;
      toDestination = hireChallan.toDestination;
      totalAdvance = hireChallan.totalAdvance;
      totalBalance = hireChallan.totalBalance;
      totalBalancePaid = hireChallan.totalBalancePaid;
      totalDeduction = hireChallan.totalDeduction;
      totalFreight = hireChallan.totalFreight;
      totalFreightWithTax = hireChallan.totalFreightWithTax;
      weight = hireChallan.weight;
      driveAdvanceCashbyParty = hireChallan.driveAdvanceCashbyParty;
      advanceInCashDate = hireChallan.advanceInCashDate != null
          ? DateTime.parse(hireChallan.advanceInCashDate!)
          : null;
      advanceInBankDate = hireChallan.advanceInBankDate != null
          ? DateTime.parse(hireChallan.advanceInBankDate!)
          : null;
      loadingDate = hireChallan.loadingDate != null
          ? DateTime.parse(hireChallan.loadingDate!)
          : null;
      unloadingDate = hireChallan.unloadingDate != null
          ? DateTime.parse(hireChallan.unloadingDate!)
          : null;
      driveAdvanceCashbyPartyDate =
          hireChallan.driveAdvanceCashbyPartyDate != null
              ? DateTime.parse(hireChallan.driveAdvanceCashbyPartyDate!)
              : null;
      totalFreightDate = hireChallan.totalFreightDate != null
          ? DateTime.parse(hireChallan.totalFreightDate!)
          : null;
      totalBalancePaidDate = hireChallan.totalBalancePaidDate != null
          ? DateTime.parse(hireChallan.totalBalancePaidDate!)
          : null;
      labourAndParkingCharges = hireChallan.labourAndParkingCharges;
    }
  }

  //form global key
  final _formKey = GlobalKey<FormState>();
  final consignerDropdownKey = GlobalKey<DropdownSearchState>();
  final consignerSearchController = TextEditingController();
  final consignerAddressDropdownKey = GlobalKey<DropdownSearchState>();
  final driverDropdownKey = GlobalKey<DropdownSearchState>();
  final driverSearchController = TextEditingController();
  final vehicleDropdownKey = GlobalKey<DropdownSearchState>();
  final vehicleSearchController = TextEditingController();

  //loading boolean
  bool _loading = false;

  @override
  void initState() {
    futureResources = backendAPI.getAllResources();
    prefillForm(widget.hireChallan);
    super.initState();
  }

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
            "hireChallan_form".tr,
            style: const TextStyle(
              fontSize: 22,
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
                  List<dynamic> listCustomers = snapshot.data!['customers'];
                  List<dynamic> listDriver = snapshot.data!['drivers'];
                  List<dynamic> listVehicle = snapshot.data!['vehicles'];
                  var user = snapshot.data!['user'];
                  return SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //consigner dropdown
                            DropdownSearch<dynamic>(
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: textInputDecoration
                                      .copyWith(labelText: "transporter".tr)),
                              selectedItem: transporter,
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
                                          Text("add_transporter".tr + " ?"),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CustomerForm(
                                                              customer: null,
                                                              screenHeight:
                                                                  screenHeight)));
                                              if (result == true) {
                                                setState(() {
                                                  consignerDropdownKey
                                                      .currentState
                                                      ?.closeDropDownSearch();
                                                  futureResources = backendAPI
                                                      .getAllResources();
                                                });
                                              }
                                            },
                                            child: const Icon(
                                                Icons.add_circle_outline_sharp),
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
                                        vertical: 8, horizontal: 20),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScaleFactor * 16),
                                        ),

                                        Text(
                                          "GST In. ${item.gstIn}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: textScaleFactor * 14),
                                        ),
                                        Text(
                                          "PAN No. ${item.pan}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: textScaleFactor * 14),
                                        ),
                                        // SizedBox(
                                        //   height: screenHeight*0.01,
                                        // ),
                                      ],
                                    ),
                                  );
                                },
                                searchFieldProps: TextFieldProps(
                                  controller: consignerSearchController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "search_transporter_by_name".tr,
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        consignerSearchController.clear();
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
                                setState(() {
                                  transporter = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            // driver dropdown
                            DropdownSearch<dynamic>(
                              selectedItem: driver,
                              key: driverDropdownKey,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: textInputDecoration
                                      .copyWith(labelText: "driver".tr)),
                              // selectedItem:
                              //     driver != null ? driver?.name : null,
                              items: listDriver,
                              itemAsString: (driver) => driver.name,
                              popupProps: PopupProps.modalBottomSheet(
                                title: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("add_driver".tr + " ? "),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DriverForm(
                                                            driver: null,
                                                          )));
                                              if (result == true) {
                                                setState(() {
                                                  driverDropdownKey.currentState
                                                      ?.closeDropDownSearch();
                                                  futureResources = backendAPI
                                                      .getAllResources();
                                                });
                                              }
                                            },
                                            child: const Icon(
                                                Icons.add_circle_outline_sharp),
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
                                        vertical: 8, horizontal: 20),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item?.name,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScaleFactor * 16),
                                        ),
                                        Text(
                                          item?.mobileNumber,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: textScaleFactor * 14),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                searchFieldProps: TextFieldProps(
                                  controller: driverSearchController,
                                  decoration: InputDecoration(
                                    hintText: "search_driver_by_name".tr,
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        driverSearchController.clear();
                                      },
                                    ),
                                    border: const OutlineInputBorder(
                                      gapPadding: 4,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                  ),
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              onChanged: (val) async {
                                setState(() {
                                  driver = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            // vehicle dropdown
                            DropdownSearch<dynamic>(
                              selectedItem: vehicle,
                              key: vehicleDropdownKey,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: textInputDecoration
                                      .copyWith(labelText: "vehicle".tr)),
                              items: listVehicle,
                              itemAsString: (vehicle) => vehicle.vehicleNumber,
                              popupProps: PopupProps.modalBottomSheet(
                                title: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Text("add_vehicle".tr + " ?"),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () async {
                                              var result = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const VehicleForm(
                                                            vehicle: null,
                                                          )));
                                              if (result == true) {
                                                setState(() {
                                                  vehicleDropdownKey
                                                      .currentState
                                                      ?.closeDropDownSearch();
                                                  futureResources = backendAPI
                                                      .getAllResources();
                                                });
                                              }
                                            },
                                            child: const Icon(
                                                Icons.add_circle_outline_sharp),
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
                                        vertical: 8, horizontal: 20),
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.vehicleNumber,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScaleFactor * 16),
                                        ),
                                        Text(
                                          item.vehicleType,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: textScaleFactor * 14),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                searchFieldProps: TextFieldProps(
                                  controller: vehicleSearchController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                    hintText: "search_vehicle_by_name".tr,
                                    suffixIcon: IconButton(
                                      icon: const Icon(Icons.clear),
                                      onPressed: () {
                                        vehicleSearchController.clear();
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
                                setState(() {
                                  vehicle = val;
                                });
                              },
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            const Divider(),
                            //loading and unloading date
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
                                  Row(
                                    children: [
                                      Text(
                                        "loading_date".tr + " : ",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 16),
                                      ),
                                      Text(
                                        loadingDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(loadingDate!)
                                            : "",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 16),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        // style: ButtonStyle(
                                        //   backgroundColor:
                                        //       MaterialStateProperty.all(
                                        //     kPrimaryColor,
                                        //   ),
                                        // ),
                                        onPressed: () async =>
                                            _loadingDateSelector(context),
                                        icon: const Icon(
                                          Icons.calendar_month_outlined,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: screenHeight * 0.015,
                                  ),
                                  // "unloadingDate": "2023-01-20T06:37:53.628Z",
                                  //Date Time
                                  Row(
                                    children: [
                                      Text(
                                        "unload_date".tr + " : ",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 16),
                                      ),
                                      Text(
                                        unloadingDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(unloadingDate!)
                                            : "",
                                        style: TextStyle(
                                            fontSize: textScaleFactor * 16),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        // style: ButtonStyle(
                                        //   backgroundColor:
                                        //       MaterialStateProperty.all(
                                        //     kPrimaryColor,
                                        //   ),
                                        // ),
                                        onPressed: () async =>
                                            _unloadingDateSelector(context),
                                        icon: const Icon(
                                          Icons.calendar_month_outlined,
                                          // color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            //weight
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "weight".tr),
                              initialValue: weight,
                              onChanged: (val) {
                                setState(() {
                                  weight = val;
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
                            //rate
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "rate".tr),
                              initialValue: rate,
                              onChanged: (val) {
                                setState(() {
                                  rate = val;
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
                            //from
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "from".tr),
                              initialValue: fromSource,
                              onChanged: (val) {
                                setState(() {
                                  fromSource = val;
                                });
                              },
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            //destination
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "to".tr),
                              initialValue: toDestination,
                              onChanged: (val) {
                                setState(() {
                                  toDestination = val;
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
                            const Divider(),

                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "person_name".tr),
                              initialValue: personName,
                              onChanged: (val) {
                                setState(() {
                                  personName = val;
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
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "person_number".tr),
                              initialValue: personNumber,
                              onChanged: (val) {
                                setState(() {
                                  personNumber = val;
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
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "person_designation".tr),
                              initialValue: personDesignation,
                              onChanged: (val) {
                                setState(() {
                                  personDesignation = val;
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
                            const Divider(),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            // radio tile list
                            Column(
                              children: [
                                Text(
                                  "Balance Type",
                                  style:
                                      TextStyle(fontSize: textScaleFactor * 16),
                                ),
                                //TBB
                                RadioListTile(
                                  title: const Text(
                                    "TBB",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: "TBB",
                                  groupValue: balanceType,
                                  onChanged: (value) {
                                    setState(() {
                                      balanceType = value.toString();
                                      isBalance = false;
                                    });
                                  },
                                ),
                                // Jama No
                                RadioListTile(
                                  title: const Text(
                                    "FIXED RATE",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: "FIXED RATE",
                                  groupValue: balanceType,
                                  onChanged: (value) {
                                    setState(() {
                                      balanceType = value.toString();
                                      isBalance = false;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: const Text(
                                    "TO PAY",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: "TO PAY",
                                  groupValue: balanceType,
                                  onChanged: (value) {
                                    setState(() {
                                      balanceType = value.toString();
                                      isBalance = false;
                                    });
                                  },
                                ),
                                // Balance
                                RadioListTile(
                                  title: const Text(
                                    "BALANCE",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  value: "BALANCE",
                                  groupValue: balanceType,
                                  onChanged: (value) {
                                    setState(() {
                                      balanceType = value.toString();
                                      isBalance = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            isBalance
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        //total Freight
                                        TextFormField(
                                          keyboardType: TextInputType.number,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText: "total_freight".tr,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                          ),
                                          // decoration:
                                          //     textInputDecoration.copyWith(
                                          //         labelText:
                                          //             "Total Freight".tr),
                                          initialValue: totalFreight != null
                                              ? totalFreight.toString()
                                              : "",
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                totalFreight = int.parse(val);
                                              });
                                            } else {
                                              setState(() {
                                                totalFreight = null;
                                              });
                                            }
                                          },
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        // totalFreight Date
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "date".tr + " : ",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              Text(
                                                totalFreightDate != null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                            totalFreightDate!)
                                                    : "",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                // style: ButtonStyle(
                                                //   backgroundColor:
                                                //       MaterialStateProperty.all(
                                                //     kPrimaryColor,
                                                //   ),
                                                // ),
                                                onPressed: () async =>
                                                    _totalFreightDateSelector(
                                                        context),
                                                icon: const Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            // CGST TEXTFIELD
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   decoration: textInputDecoration.copyWith(
                            //       labelText: "CGST".tr),
                            //   initialValue: cgst != null ? cgst.toString() : '',
                            //   onChanged: (val) {
                            //     setState(() {
                            //       cgst = double.parse(val);
                            //     });
                            //   },
                            //   keyboardType: TextInputType.text,
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: screenHeight * 0.015,
                            // ),
                            // IGST TEXTFIELD
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   decoration: textInputDecoration.copyWith(
                            //       labelText: "IGST".tr),
                            //   initialValue: igst != null ? igst.toString() : '',
                            //   onChanged: (val) {
                            //     setState(() {
                            //       igst = double.parse(val);
                            //     });
                            //   },
                            //   keyboardType: TextInputType.text,
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: screenHeight * 0.015,
                            // ),
                            // SGST TEXTFIELD
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   decoration: textInputDecoration.copyWith(
                            //       labelText: "SGST".tr),
                            //   initialValue: sgst != null ? sgst.toString() : '',
                            //   onChanged: (val) {
                            //     setState(() {
                            //       sgst = double.parse(val);
                            //     });
                            //   },
                            //   keyboardType: TextInputType.text,
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: screenHeight * 0.015,
                            // ),
                            //Radio List Tile for GST Type Select
                            // isBalance
                            //     ? Column(
                            //         children: [
                            //           Text(
                            //             "GST Type",
                            //             style: TextStyle(
                            //                 fontSize: textScaleFactor * 16),
                            //           ),
                            //           //TBB
                            //           RadioListTile(
                            //             title: const Text(
                            //               "SGST/CGST",
                            //               style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.bold,
                            //                 color: Colors.black,
                            //               ),
                            //             ),
                            //             value: "SGST",
                            //             groupValue: gstType,
                            //             onChanged: (value) {
                            //               setState(() {
                            //                 gstType = value.toString();
                            //                 isTaxTypeIgst = false;
                            //               });
                            //             },
                            //           ),
                            //           // Jama No
                            //           RadioListTile(
                            //             title: const Text(
                            //               "IGST",
                            //               style: TextStyle(
                            //                 fontSize: 16,
                            //                 fontWeight: FontWeight.bold,
                            //                 color: Colors.black,
                            //               ),
                            //             ),
                            //             value: "IGST",
                            //             groupValue: gstType,
                            //             onChanged: (value) {
                            //               setState(() {
                            //                 gstType = value.toString();
                            //                 isTaxTypeIgst = true;
                            //               });
                            //             },
                            //           ),
                            //         ],
                            //       )
                            //     : SizedBox(),
                            // isBalance
                            //     ? SizedBox(
                            //         height: screenHeight * 0.015,
                            //       )
                            //     : SizedBox(),
                            // isBalance
                            //     ? TextFormField(
                            //         textCapitalization:
                            //             TextCapitalization.characters,
                            //         decoration: textInputDecoration.copyWith(
                            //             labelText: "GST Percentage".tr),
                            //         initialValue: gstPercentage != null
                            //             ? gstPercentage.toString()
                            //             : '',
                            //         onChanged: (val) {
                            //           if (val != "") {
                            //             setState(() {
                            //               gstPercentage = double.parse(val);
                            //             });
                            //           } else {
                            //             setState(() {
                            //               gstPercentage = null;
                            //             });
                            //           }
                            //         },
                            //         keyboardType: TextInputType.number,
                            //         style: const TextStyle(
                            //           color: Colors.black,
                            //         ),
                            //       )
                            //     : SizedBox(),
                            // isBalance
                            //     ? SizedBox(
                            //         height: screenHeight * 0.015,
                            //       )
                            //     : SizedBox(),
                            // TextFormField(
                            //   textCapitalization: TextCapitalization.characters,
                            //   decoration: textInputDecoration.copyWith(
                            //       labelText: "Total Freight With Tax".tr),
                            //   initialValue: totalFreightWithTax != null
                            //       ? totalFreightWithTax.toString()
                            //       : '',
                            //   onChanged: (val) {
                            //     setState(() {
                            //       totalFreightWithTax = int.parse(val);
                            //     });
                            //   },
                            //   keyboardType: TextInputType.text,
                            //   style: const TextStyle(
                            //     color: Colors.black,
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: screenHeight * 0.015,
                            // ),
                            //isBalance ? const Divider() : const SizedBox(),
                            // isBalance
                            //     ? SizedBox(
                            //         height: screenHeight * 0.015,
                            //       )
                            //     : const SizedBox(),
                            isBalance
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText: "advance_in_bank".tr,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                          ),
                                          initialValue: advanceInBank != null
                                              ? advanceInBank.toString()
                                              : '',
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                advanceInBank = int.parse(val);
                                              });
                                            } else {
                                              setState(() {
                                                advanceInBank = null;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "date".tr + " : ",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              Text(
                                                advanceInBankDate != null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                            advanceInBankDate!)
                                                    : "",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                // style: ButtonStyle(
                                                //   backgroundColor:
                                                //       MaterialStateProperty.all(
                                                //     Colors.black,
                                                //   ),
                                                // ),
                                                onPressed: () async =>
                                                    _advanceInBankDateSelector(
                                                        context),
                                                icon: const Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText: "advance_in_cash".tr,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                          ),
                                          initialValue: advanceInCash != null
                                              ? advanceInCash.toString()
                                              : '',
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                advanceInCash = int.parse(val);
                                              });
                                            } else {
                                              setState(() {
                                                advanceInCash = null;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                "date".tr + " : ",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              Text(
                                                advanceInCashDate != null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                            advanceInCashDate!)
                                                    : "",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                // style: ButtonStyle(
                                                //   backgroundColor:
                                                //       MaterialStateProperty.all(
                                                //     Colors.black,
                                                //   ),
                                                // ),
                                                onPressed: () async =>
                                                    _advanceInCashDateSelector(
                                                        context),
                                                icon: const Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText:
                                                "driver_cash_by_party".tr,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                          ),
                                          initialValue:
                                              driveAdvanceCashbyParty != null
                                                  ? driveAdvanceCashbyParty
                                                      .toString()
                                                  : '',
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                driveAdvanceCashbyParty =
                                                    int.parse(val);
                                              });
                                            } else {
                                              setState(() {
                                                driveAdvanceCashbyParty = null;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "date".tr + " : ",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              Text(
                                                driveAdvanceCashbyPartyDate !=
                                                        null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                            driveAdvanceCashbyPartyDate!)
                                                    : "",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                // style: ButtonStyle(
                                                //   backgroundColor:
                                                //       MaterialStateProperty.all(
                                                //     Colors.black,
                                                //   ),
                                                // ),
                                                onPressed: () async =>
                                                    _driveAdvanceCashbyPartyDateSelector(
                                                        context),
                                                icon: const Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: "tds".tr),
                                    initialValue:
                                        tds != null ? tds.toString() : '',
                                    onChanged: (val) {
                                      if (val != "") {
                                        setState(() {
                                          tds = int.parse(val);
                                        });
                                      } else {
                                        setState(() {
                                          tds = null;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: textInputDecoration.copyWith(
                                        labelText: "total_deduction".tr),
                                    initialValue: totalDeduction != null
                                        ? totalDeduction.toString()
                                        : "",
                                    onChanged: (val) {
                                      if (val != "") {
                                        setState(() {
                                          totalDeduction = int.parse(val);
                                        });
                                      } else {
                                        setState(() {
                                          totalDeduction = null;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText: "total_balance_paid".tr,
                                            border: InputBorder.none,
                                            contentPadding:
                                                const EdgeInsets.all(8),
                                          ),
                                          initialValue: totalBalancePaid != null
                                              ? totalBalancePaid.toString()
                                              : '',
                                          onChanged: (val) {
                                            if (val != "") {
                                              setState(() {
                                                totalBalancePaid =
                                                    int.parse(val);
                                              });
                                            } else {
                                              setState(() {
                                                totalBalancePaid = null;
                                              });
                                            }
                                          },
                                          keyboardType: TextInputType.number,
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "date".tr + " : ",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              Text(
                                                totalBalancePaidDate != null
                                                    ? DateFormat('dd-MM-yyyy')
                                                        .format(
                                                            totalBalancePaidDate!)
                                                    : "",
                                                style: TextStyle(
                                                    fontSize:
                                                        textScaleFactor * 16),
                                              ),
                                              const Spacer(),
                                              IconButton(
                                                // style: ButtonStyle(
                                                //   backgroundColor:
                                                //       MaterialStateProperty.all(
                                                //     Colors.black,
                                                //   ),
                                                // ),
                                                onPressed: () async =>
                                                    _totalBalanceDateSelector(
                                                        context),
                                                icon: const Icon(Icons
                                                    .calendar_month_outlined),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            isBalance
                                ? TextFormField(
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    decoration: textInputDecoration.copyWith(
                                        labelText:
                                            "labourAndParkingCharges".tr),
                                    initialValue:
                                        labourAndParkingCharges != null
                                            ? labourAndParkingCharges.toString()
                                            : '',
                                    onChanged: (val) {
                                      if (val != "") {
                                        setState(() {
                                          labourAndParkingCharges =
                                              int.parse(val);
                                        });
                                      } else {
                                        setState(() {
                                          labourAndParkingCharges = null;
                                        });
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(
                                      color: Colors.black,
                                    ),
                                  )
                                : const SizedBox(),
                            isBalance
                                ? SizedBox(
                                    height: screenHeight * 0.015,
                                  )
                                : const SizedBox(),
                            TextFormField(
                              textCapitalization: TextCapitalization.characters,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "remarks".tr),
                              initialValue: remarks,
                              onChanged: (val) {
                                setState(() {
                                  remarks = val;
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
                            ElevatedButton(
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all(
                                    const Size(double.infinity, 50)),
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.black,
                                ),
                              ),
                              onPressed: _loading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _loading = true;
                                        });

                                        //creating Hire Challan
                                        HireChallan hireChallan = HireChallan(
                                            id: widget.hireChallan?.id,
                                            hireChallanNumber: null,
                                            suffixHireChallanNumber: null,
                                            createdTime: null,
                                            company: user.company,
                                            vehicle: vehicle,
                                            driver: driver,
                                            transporter: transporter,
                                            //consignerAddress: consignerAddress,
                                            createdBy: user,
                                            fromSource: fromSource,
                                            //gstPercentage: gstPercentage,
                                            toDestination: toDestination,
                                            personName: personName,
                                            personNumber: personNumber,
                                            personDesignation:
                                                personDesignation,
                                            totalFreight: totalFreight,
                                            totalFreightDate:
                                                totalFreightDate != null
                                                    ? convertDateTimeToString(
                                                        totalFreightDate!)
                                                    : null,
                                            isBalance: isBalance,
                                            //isTaxTypeIGST: isTaxTypeIgst,
                                            weight: weight,
                                            rate: rate,
                                            advanceInBank: advanceInBank,
                                            advanceInBankDate:
                                                advanceInBankDate != null
                                                    ? convertDateTimeToString(
                                                        advanceInBankDate!)
                                                    : null,
                                            advanceInCash: advanceInCash,
                                            advanceInCashDate:
                                                advanceInCashDate != null
                                                    ? convertDateTimeToString(
                                                        advanceInCashDate!)
                                                    : null,
                                            balance: balance,
                                            balanceType: balanceType,
                                            driveAdvanceCashbyParty:
                                                driveAdvanceCashbyParty,
                                            driveAdvanceCashbyPartyDate:
                                                driveAdvanceCashbyPartyDate !=
                                                        null
                                                    ? convertDateTimeToString(
                                                        driveAdvanceCashbyPartyDate!)
                                                    : null,
                                            remarks: remarks,
                                            tds: tds,
                                            totalAdvance: totalAdvance,
                                            totalBalance: totalBalance,
                                            totalBalancePaid: totalBalancePaid,
                                            totalBalancePaidDate:
                                                totalBalancePaidDate != null
                                                    ? convertDateTimeToString(
                                                        totalBalancePaidDate!)
                                                    : null,
                                            totalDeduction: totalDeduction,
                                            totalFreightWithTax:
                                                totalFreightWithTax,
                                            loadingDate: loadingDate != null
                                                ? convertDateTimeToString(
                                                    loadingDate!)
                                                : null,
                                            unloadingDate: unloadingDate != null
                                                ? convertDateTimeToString(
                                                    unloadingDate!)
                                                : null,
                                            labourAndParkingCharges:
                                                labourAndParkingCharges);
                                        if (widget.hireChallan == null) {
                                          var result = await backendAPI
                                              .addHireChallan(hireChallan);
                                          if (result != false) {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HireChallanDetails(
                                                            hireChallan:
                                                                result)));
                                            Get.snackbar(
                                              "success".tr,
                                              "success_message_for_create".tr,
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
                                              "error_message_for_create".tr,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white,
                                            );
                                          }
                                        } else {
                                          var result = await backendAPI
                                              .updateHireChallan(hireChallan);
                                          if (result != false) {
                                            Navigator.pop(context, result);
                                            Get.snackbar(
                                              "success".tr,
                                              "success_message_for_update".tr,
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
                                              "error_message_for_update".tr,
                                              snackPosition:
                                                  SnackPosition.BOTTOM,
                                              backgroundColor: Colors.black,
                                              colorText: Colors.white,
                                            );
                                          }
                                        }
                                      }
                                    },
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
                                      "submit".tr,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
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
                              futureResources = backendAPI.getAllResources();
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
                } else {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Network Error has Occurred"),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              futureResources = backendAPI.getAllResources();
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
    });
  }
}
