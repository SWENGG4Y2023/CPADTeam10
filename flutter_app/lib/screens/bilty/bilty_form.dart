import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/models/description.dart';
import 'package:transport_bilty_generator/screens/bilty/view_bilty_details.dart';
import 'package:transport_bilty_generator/screens/customer/customer_form.dart';
import 'package:transport_bilty_generator/screens/driver/driver_form.dart';
import 'package:transport_bilty_generator/screens/vehicle/vehicle_form.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class BiltyForm extends StatefulWidget {
  final Bilty? bilty;
  final double screenHeight;

  const BiltyForm({Key? key, required this.bilty, required this.screenHeight})
      : super(key: key);

  @override
  State<BiltyForm> createState() => _BiltyFormState();
}

class _BiltyFormState extends State<BiltyForm> {
  final BackendAPI backendAPI = BackendAPI();
  late Future<Map<String, dynamic>?> futureResources;

  //ewayBillDate
  DateTime? ewayBillDate;

  // function for getting date and time
  Future<void> _ewayBillDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: ewayBillDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != ewayBillDate) {
      setState(() {
        ewayBillDate = picked;
      });
    }
  }

  // pickupDate
  DateTime? pickupDate;

  // function for getting date and time
  Future<void> _pickUpDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: pickupDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != pickupDate) {
      setState(() {
        pickupDate = picked;
      });
    }
  }

  // // unload date
  // DateTime unloadDate = DateTime.now();
  //
  // // function for getting date and time
  // Future<void> _unloadDateSelector(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     builder: (context, child) {
  //       return Theme(
  //         data: ThemeData.light().copyWith(
  //           colorScheme: const ColorScheme(
  //             primary: kPrimaryColor,
  //             secondary: kPrimaryColor,
  //             surface: kPrimaryColor,
  //             background: kPrimaryColor,
  //             error: kPrimaryColor,
  //             onPrimary: Colors.black,
  //             onSecondary: Colors.black,
  //             onSurface: Colors.black,
  //             onBackground: Colors.black,
  //             onError: Colors.black,
  //             brightness: Brightness.light,
  //           ),
  //           dialogBackgroundColor: Colors.white,
  //         ),
  //         child: child!,
  //       );
  //     },
  //     context: context,
  //     initialDate: unloadDate,
  //     firstDate: DateTime(2015, 8),
  //     lastDate: DateTime(2101),
  //   );
  //   if (picked != null && picked != unloadDate) {
  //     setState(() {
  //       unloadDate = picked;
  //     });
  //   }
  // }

  var consigner;
  var consignee;
  var vehicle;
  var driver;
  String? _advance;
  String? _billtyCharges;
  String? _biltyType;
  bool? _isFreight = false;
  String? _freight;
  String? _grandTotal;
  String? _billTo;
  String? _ewayBillNumber;
  String? _invoiceNumber;
  String? _invoiceValue;
  String? _netWeight;
  String? _grossWeight;
  String? _receiverContact;
  String? _receiverName;
  String? _remarks;
  String? _insuranceNumber;

  // String? _gstAmount;
  String? _totalAmount;
  // String? _weight;
  List<dynamic> consignerAddressList = [];
  var consignerAddress;
  List<dynamic> consigneeAddressList = [];
  var consigneeAddress;
  List _descriptionField = [];

  //List<TextEditingController> _descriptionControllers = [];
  List<TextEditingController> _descriptionNameControllers = [];
  List<TextEditingController> _descriptionPacketControllers = [];
  List<TextEditingController> _descriptionTypeControllers = [];
  List<TextEditingController> _descriptionWeightControllers = [];

  //function to prefill the form
  void prefillForm(Bilty? bilty, double screenHeight) {
    if (bilty != null) {
      consigner = bilty.consigner;
      consignee = bilty.consignee;
      consignerAddress = bilty.consignerAddress;
      consignerAddressList = bilty.consigner!.address;
      consigneeAddressList = bilty.consignee!.address;
      consigneeAddress = bilty.consigneeAddress;
      driver = bilty.driver;
      vehicle = bilty.vehicle;
      _advance = bilty.advance != null ? bilty.advance.toString() : "";
      _billtyCharges =
          bilty.billtyCharges != null ? bilty.billtyCharges.toString() : "";
      _biltyType = bilty.biltyType;
      _isFreight = bilty.isFreight;
      _freight = bilty.freight != null ? bilty.freight.toString() : "";
      _grandTotal = bilty.grandTotal != null ? bilty.grandTotal.toString() : "";
      _billTo = bilty.billTo;
      _ewayBillNumber = bilty.ewayBillNumber;
      _invoiceNumber = bilty.invoiceNumber;
      _invoiceValue = bilty.invoiceValue;
      _netWeight = bilty.netWeight;
      _grossWeight = bilty.grossWeight;
      _receiverContact = bilty.receiverContact;
      _receiverName = bilty.receiverName;
      _remarks = bilty.remarks;
      _insuranceNumber = bilty.insuranceNumber;
      //_gstAmount = bilty.gstAmount != null ? bilty.gstAmount.toString() : "";
      _totalAmount = _totalAmount =
          bilty.totalAmount != null ? bilty.totalAmount.toString() : "";
      ewayBillDate = bilty.ewayBillDate != null
          ? DateTime.parse(bilty.ewayBillDate!)
          : null;
      pickupDate =
          bilty.pickupDate != null ? DateTime.parse(bilty.pickupDate!) : null;
      //unloadDate = DateTime.parse(bilty.unloadDate!);

      _descriptionNameControllers = List.generate(
          bilty.description!.length,
          (index) =>
              TextEditingController(text: bilty.description?[index].name));
      _descriptionPacketControllers = List.generate(
          bilty.description!.length,
          (index) =>
              TextEditingController(text: bilty.description?[index].packet));
      _descriptionTypeControllers = List.generate(
          bilty.description!.length,
          (index) =>
              TextEditingController(text: bilty.description?[index].type));
      _descriptionWeightControllers = List.generate(
          bilty.description!.length,
          (index) =>
              TextEditingController(text: bilty.description?[index].weight));
      _descriptionField = List.generate(
          bilty.description!.length,
          (index) => GetBuilder<LocalizationController>(
                builder: (localizationController) {
                  return ExpandablePanel(
                      theme: const ExpandableThemeData(
                        headerAlignment: ExpandablePanelHeaderAlignment.center,
                        tapBodyToCollapse: false,
                      ),
                      header: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text("description".tr + " ${index + 1}",
                            style: const TextStyle(
                              fontSize: 18,
                            )),
                      ),
                      collapsed: Column(
                        children: [
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Name".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            controller: _descriptionNameControllers[index],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          // City
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Type".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            controller: _descriptionTypeControllers[index],
                          ),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          //State
                          TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "Packet".tr),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _descriptionPacketControllers[index],
                              keyboardType: TextInputType.number),
                          SizedBox(
                            height: screenHeight * 0.01,
                          ),
                          TextFormField(
                            // validator: (val) {
                            //   return val!.isEmpty == true
                            //       ? "".tr
                            //       : null;
                            // },
                            decoration: textInputDecoration.copyWith(
                                labelText: "Weight".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            controller: _descriptionWeightControllers[index],
                          ),
                        ],
                      ),
                      expanded: const SizedBox());
                },
              ));
    }
  }

  @override
  void initState() {
    futureResources = backendAPI.getAllResources();
    _isFreight = false;
    _biltyType = "TBB";
    prefillForm(widget.bilty, widget.screenHeight);
    super.initState();
  }

  //loading boolean
  bool _loading = false;

  // function to add descriptionField
  Widget _addDescriptionField(double screenHeight) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return IconButton(
        onPressed: () {
          //final descriptionController = TextEditingController();
          final typeController = TextEditingController();
          final nameController = TextEditingController();
          final packetController = TextEditingController();
          final weightController = TextEditingController();
          final field = ExpandablePanel(
              theme: const ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                tapBodyToCollapse: false,
              ),
              header: Padding(
                padding: const EdgeInsets.all(10),
                child:
                    Text("description".tr + " ${_descriptionField.length + 1}",
                        style: const TextStyle(
                          fontSize: 18,
                        )),
              ),
              collapsed: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    decoration:
                        textInputDecoration.copyWith(labelText: "name".tr),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: nameController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  // City
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
                    decoration:
                        textInputDecoration.copyWith(labelText: "type".tr),
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                    controller: typeController,
                  ),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  //State
                  TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      decoration:
                          textInputDecoration.copyWith(labelText: "packet".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: packetController,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                  TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      // validator: (val) {
                      //   return val!.isEmpty == true ? "Enter Packet".tr : null;
                      // },
                      decoration:
                          textInputDecoration.copyWith(labelText: "weight".tr),
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      controller: weightController,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: screenHeight * 0.01,
                  ),
                ],
              ),
              expanded: const SizedBox());
          setState(() {
            _descriptionField.add(field);
            _descriptionNameControllers.add(nameController);
            _descriptionTypeControllers.add(typeController);
            _descriptionPacketControllers.add(packetController);
            _descriptionWeightControllers.add(weightController);
          });
        },
        icon: const CircleAvatar(
          radius: 13,
          child: Icon(Icons.add, color: Colors.white, size: 22),
          backgroundColor: Colors.black,
        ),
      );
    });
  }

  // remove Description Exp Tile
  Widget _removeDescriptionField() {
    return IconButton(
        onPressed: () {
          setState(() {
            _descriptionNameControllers.removeLast();
            _descriptionTypeControllers.removeLast();
            _descriptionPacketControllers.removeLast();
            _descriptionWeightControllers.removeLast();
            _descriptionField.removeLast();
          });
        },
        icon: const CircleAvatar(
          radius: 13,
          child: Icon(Icons.remove, color: Colors.white, size: 22),
          backgroundColor: Colors.black,
        ));
  }

  // widget creating
  Widget _listViewDescriptionTile() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _descriptionNameControllers.length,
      itemBuilder: (context, index) {
        return Container(
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: _descriptionField[index]);
      },
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < _descriptionNameControllers.length; i++) {
      //_descriptionControllers[i].dispose();
      _descriptionNameControllers[i].dispose();
      _descriptionPacketControllers[i].dispose();
      _descriptionTypeControllers[i].dispose();
      _descriptionWeightControllers[i].dispose();
    }
    consignerSearchController.dispose();
    consigneeSearchController.dispose();
    vehicleSearchController.dispose();
    driverSearchController.dispose();
    super.dispose();
  }

  // form Global Key
  final _formKey = GlobalKey<FormState>();
  final consignerDropdownKey = GlobalKey<DropdownSearchState>();
  final consignerSearchController = TextEditingController();
  final consignerAddressDropdownKey = GlobalKey<DropdownSearchState>();
  final consigneeDropdownKey = GlobalKey<DropdownSearchState>();
  final consigneeAddressDropdownKey = GlobalKey<DropdownSearchState>();
  final consigneeSearchController = TextEditingController();
  final driverDropdownKey = GlobalKey<DropdownSearchState>();
  final driverSearchController = TextEditingController();
  final vehicleDropdownKey = GlobalKey<DropdownSearchState>();
  final vehicleSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "bilty_form".tr,
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
                    // creating local variables for better accessability
                    List<dynamic> listCustomers = snapshot.data!['customers'];
                    List<dynamic> listDriver = snapshot.data!["drivers"];
                    List<dynamic> listVehicle = snapshot.data!["vehicles"];
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
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "consigner_name".tr)),
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
                                            Text("add_consigner".tr + " ?"),
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
                                        ],
                                      ),
                                    );
                                  },
                                  searchFieldProps: TextFieldProps(
                                    controller: consignerSearchController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "search_consigner_by_name".tr,
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
                                    consignerAddressList = val.address;
                                  });
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              //consigner address
                              DropdownSearch<dynamic>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "consigner_address".tr)),
                                key: consignerAddressDropdownKey,
                                items: consignerAddressList,
                                selectedItem: consignerAddress?.address,
                                popupProps: PopupProps.modalBottomSheet(
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 15),
                                    child: Column(
                                      children: [
                                        Text("select_address".tr),
                                      ],
                                    ),
                                  ),
                                  modalBottomSheetProps: modalBottomSheetProps,
                                  // modalBottomSheetProps: modalBottomSheetProps,
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
                                            item.address,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textScaleFactor * 16),
                                          ),
                                          Text(
                                            item.city,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            item.state,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            item.zipCode.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    consignerAddress = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              //consignee dropdown
                              DropdownSearch<dynamic>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "consignee_name".tr)),
                                selectedItem: consignee,
                                key: consigneeDropdownKey,
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
                                            Text("add_consignee".tr + " ?"),
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
                                                    futureResources = backendAPI
                                                        .getAllResources();
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
                                        ],
                                      ),
                                    );
                                  },
                                  searchFieldProps: TextFieldProps(
                                    controller: consigneeSearchController,
                                    style: const TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                      hintText: "search_consignee_by_name".tr,
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.clear),
                                        onPressed: () {
                                          consigneeSearchController.clear();
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
                                  //   consignee = customer[0];
                                  //   consigneeAddressList = customer[0].address;
                                  // });
                                  setState(() {
                                    consignee = val;
                                    consigneeAddressList = val.address;
                                  });
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // consignee address dropdown
                              DropdownSearch<dynamic>(
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "consignee_address".tr)),
                                key: consigneeAddressDropdownKey,
                                items: consigneeAddressList,
                                selectedItem: consigneeAddress?.address,
                                popupProps: PopupProps.modalBottomSheet(
                                  title: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    child: Column(
                                      children: [
                                        Text("select_address".tr),
                                      ],
                                    ),
                                  ),
                                  modalBottomSheetProps: modalBottomSheetProps,
                                  // modalBottomSheetProps: modalBottomSheetProps,
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
                                            item.address,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: textScaleFactor * 16),
                                          ),
                                          Text(
                                            item.city,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            item.state,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                          Text(
                                            item.zipCode.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: textScaleFactor * 14),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    consigneeAddress = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              const Divider(),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // driver dropdown
                              DropdownSearch<dynamic>(
                                selectedItem: driver,
                                key: driverDropdownKey,
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "driver_name".tr)),
                                // selectedItem:
                                //     driver != null ? driver?.name : null,
                                items: listDriver,
                                itemAsString: (driver) {
                                  return driver.name;
                                },
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
                                                var result =
                                                    await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const DriverForm(
                                                                  driver: null,
                                                                )));
                                                if (result == true) {
                                                  setState(() {
                                                    driverDropdownKey
                                                        .currentState
                                                        ?.closeDropDownSearch();
                                                    futureResources = backendAPI
                                                        .getAllResources();
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
                                  // using the searchDriver method here to get the customer details
                                  // // and forwarding to the customer Page
                                  // List searchDriver =
                                  //     await backendAPI.getDriverBySearch(val);
                                  // if (searchDriver.isNotEmpty) {
                                  //   setState(() {
                                  //     driver = searchDriver[0];
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     driverDropdownKey.currentState?.clear();
                                  //   });
                                  // }
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
                                    dropdownSearchDecoration:
                                        textInputDecoration.copyWith(
                                            labelText: "vehicle_number".tr)),
                                items: listVehicle,
                                itemAsString: (vehicle) =>
                                    vehicle.vehicleNumber,
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
                                                var result =
                                                    await Navigator.push(
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
                                          vertical: 8, horizontal: 20),
                                      padding: EdgeInsets.all(10),
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
                                  // using the searchDriver method here to get the customer details
                                  // and forwarding to the customer Page
                                  // List searchVehicle =
                                  //     await backendAPI.getVehicleByNumber(val);
                                  // if (searchVehicle.isNotEmpty) {
                                  //   setState(() {
                                  //     vehicle = searchVehicle[0];
                                  //   });
                                  // } else {
                                  //   setState(() {
                                  //     vehicleDropdownKey.currentState?.clear();
                                  //   });
                                  // }
                                  setState(() {
                                    vehicle = val;
                                  });
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "pickupDate": "2023-01-20T06:37:53.628Z",
                              //Date Time
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
                                      "pickUp_date".tr,
                                      style: TextStyle(
                                          fontSize: textScaleFactor * 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(pickupDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(pickupDate!)
                                            : ""),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              kPrimaryColor,
                                            ),
                                          ),
                                          onPressed: () async =>
                                              _pickUpDateSelector(context),
                                          child: Text(
                                            'select_date'.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: screenHeight * 0.015,
                                    ),
                                    // "unloadingDate": "2023-01-20T06:37:53.628Z",
                                    // Text(
                                    //   "unload_date".tr,
                                    //   style: TextStyle(
                                    //       fontSize: textScaleFactor * 16),
                                    // ),
                                    //Date Time
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(DateFormat('dd-MM-yyyy')
                                    //         .format(unloadDate)),
                                    //     ElevatedButton(
                                    //       style: ButtonStyle(
                                    //         backgroundColor:
                                    //             MaterialStateProperty.all(
                                    //           Colors.black,
                                    //         ),
                                    //       ),
                                    //       onPressed: () async =>
                                    //           _unloadDateSelector(context),
                                    //       child: Text('select_date'.tr),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: screenHeight * 0.015,
                                    // ),
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
                              //eway Bill Date
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
                                      "ewayBill_date".tr,
                                      style: TextStyle(
                                          fontSize: textScaleFactor * 16),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(ewayBillDate != null
                                            ? DateFormat('dd-MM-yyyy')
                                                .format(ewayBillDate!)
                                            : ""),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              kPrimaryColor,
                                            ),
                                          ),
                                          onPressed: () async =>
                                              _ewayBillDateSelector(context),
                                          child: Text(
                                            'select_date'.tr,
                                            style: const TextStyle(
                                                color: Colors.white),
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
                              // ewayBillNumber
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "eway_billNumber".tr),
                                initialValue: _ewayBillNumber,
                                onChanged: (val) {
                                  setState(() {
                                    _ewayBillNumber = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "netWeight": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "net_weight".tr),
                                initialValue: _netWeight,
                                onChanged: (val) {
                                  setState(() {
                                    _netWeight = val;
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
                              // "grossWeigth": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "gross_weight".tr),
                                initialValue: _grossWeight,
                                onChanged: (val) {
                                  setState(() {
                                    _grossWeight = val;
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
                              Column(
                                children: [
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
                                    groupValue: _biltyType,
                                    onChanged: (value) {
                                      setState(() {
                                        _biltyType = value.toString();
                                        _isFreight = false;
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
                                    groupValue: _biltyType,
                                    onChanged: (value) {
                                      setState(() {
                                        _biltyType = value.toString();
                                        _isFreight = false;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text(
                                      "PAID",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: "PAID",
                                    groupValue: _biltyType,
                                    onChanged: (value) {
                                      setState(() {
                                        _biltyType = value.toString();
                                        _isFreight = false;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text(
                                      "FIXED",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: "FIXED",
                                    groupValue: _biltyType,
                                    onChanged: (value) {
                                      setState(() {
                                        _biltyType = value.toString();
                                        _isFreight = false;
                                      });
                                    },
                                  ),
                                  RadioListTile(
                                    title: const Text(
                                      "FREIGHT",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    value: "FREIGHT",
                                    groupValue: _biltyType,
                                    onChanged: (value) {
                                      setState(() {
                                        _biltyType = value.toString();
                                        _isFreight = true;
                                      });
                                    },
                                  )
                                ],
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              //freigth
                              _isFreight!
                                  ? TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "enter_freight".tr),
                                      initialValue: _freight,
                                      onChanged: (val) {
                                        setState(() {
                                          _freight = val;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      keyboardType: TextInputType.number)
                                  : Container(),
                              _isFreight!
                                  ? SizedBox(
                                      height: screenHeight * 0.015,
                                    )
                                  : Container(),
                              // billty charges
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    labelText: "bilty_charges".tr),
                                initialValue: _billtyCharges,
                                onChanged: (val) {
                                  setState(() {
                                    _billtyCharges = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.number,
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "totalAmount": 0,
                              _isFreight!
                                  ? TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "total_amount".tr),
                                      initialValue: _totalAmount,
                                      onChanged: (val) {
                                        setState(() {
                                          _totalAmount = val;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      keyboardType: TextInputType.number)
                                  : Container(),
                              _isFreight!
                                  ? SizedBox(
                                      height: screenHeight * 0.015,
                                    )
                                  : Container(),
                              // advance textfield
                              _isFreight!
                                  ? TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "advance".tr),
                                      initialValue: _advance,
                                      onChanged: (val) {
                                        setState(() {
                                          _advance = val;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      keyboardType: TextInputType.number)
                                  : Container(),
                              _isFreight!
                                  ? SizedBox(
                                      height: screenHeight * 0.015,
                                    )
                                  : Container(),
                              // gstAmount
                              // _isFreight!
                              //     ? TextFormField(
                              //         decoration: textInputDecoration.copyWith(
                              //             labelText: "gst_amount".tr),
                              //         initialValue: _gstAmount,
                              //         onChanged: (val) {
                              //           setState(() {
                              //             _gstAmount = val;
                              //           });
                              //         },
                              //         style: const TextStyle(
                              //           color: Colors.black,
                              //         ),
                              //         keyboardType: TextInputType.number)
                              //     : Container(),
                              // _isFreight!
                              //     ? SizedBox(
                              //         height: screenHeight * 0.015,
                              //       )
                              //     : Container(),
                              // grandtotal
                              _isFreight!
                                  ? TextFormField(
                                      decoration: textInputDecoration.copyWith(
                                          labelText: "grandTotal".tr),
                                      initialValue: _grandTotal,
                                      onChanged: (val) {
                                        setState(() {
                                          _grandTotal = val;
                                        });
                                      },
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
                                      keyboardType: TextInputType.number)
                                  : Container(),
                              _isFreight!
                                  ? SizedBox(
                                      height: screenHeight * 0.015,
                                    )
                                  : Container(),
                              // bill to
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "billTo".tr),
                                initialValue: _billTo,
                                onChanged: (val) {
                                  setState(() {
                                    _billTo = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // descriptionFields
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("description".tr,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Row(
                                      children: [
                                        _addDescriptionField(screenHeight),
                                        _removeDescriptionField(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              _listViewDescriptionTile(),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              const Divider(),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "insuranceNumber": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "insurance_number".tr),
                                initialValue: _insuranceNumber,
                                onChanged: (val) {
                                  setState(() {
                                    _insuranceNumber = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "invoiceNumber": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "invoice_number".tr),
                                initialValue: _invoiceNumber,
                                onChanged: (val) {
                                  setState(() {
                                    _invoiceNumber = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "invoiceValue": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "invoice_value".tr),
                                initialValue: _invoiceValue,
                                onChanged: (val) {
                                  setState(() {
                                    _invoiceValue = val;
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

                              // "receiverName": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "reciever_name".tr),
                                initialValue: _receiverName,
                                onChanged: (val) {
                                  setState(() {
                                    _receiverName = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "receiverContact": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "receiver_contact".tr),
                                initialValue: _receiverContact,
                                onChanged: (val) {
                                  setState(() {
                                    _receiverContact = val;
                                  });
                                },
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.015,
                              ),
                              // "remarks": "string",
                              TextFormField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: textInputDecoration.copyWith(
                                    labelText: "remarks".tr),
                                initialValue: _remarks,
                                onChanged: (val) {
                                  setState(() {
                                    _remarks = val;
                                  });
                                },
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
                                          List<Description> descriptionList =
                                              [];
                                          for (int i = 0;
                                              i <
                                                  _descriptionNameControllers
                                                      .length;
                                              i++) {
                                            Description description = Description(
                                                name:
                                                    _descriptionNameControllers[
                                                            i]
                                                        .text,
                                                packet:
                                                    _descriptionPacketControllers[
                                                            i]
                                                        .text,
                                                type:
                                                    _descriptionTypeControllers[
                                                            i]
                                                        .text,
                                                weight:
                                                    _descriptionWeightControllers[
                                                            i]
                                                        .text,
                                                id: i);
                                            descriptionList.add(description);
                                          }
                                          //creating bilty object
                                          Bilty bilty = Bilty(
                                            id: widget.bilty?.id,
                                            lrNumber: null,
                                            company: user.company,
                                            vehicle: vehicle,
                                            driver: driver,
                                            consigner: consigner,
                                            consignee: consignee,
                                            consignerAddress: consignerAddress,
                                            consigneeAddress: consigneeAddress,
                                            pickupDate: pickupDate != null
                                                ? DateFormat(
                                                            "yyyy-MM-ddTHH:mm:ss.ms")
                                                        .format(pickupDate!) +
                                                    "Z"
                                                : null,
                                            // unloadDate: DateFormat(
                                            //             "yyyy-MM-ddTHH:mm:ss.ms")
                                            //         .format(unloadDate) +
                                            //     "Z",
                                            description: descriptionList,
                                            insuranceNumber:
                                                _insuranceNumber ?? "",
                                            invoiceNumber: _invoiceNumber ?? "",
                                            invoiceValue: _invoiceValue ?? "",
                                            ewayBillNumber:
                                                _ewayBillNumber ?? "",
                                            ewayBillDate: ewayBillDate != null
                                                ? DateFormat(
                                                            "yyyy-MM-ddTHH:mm:ss.ms")
                                                        .format(ewayBillDate!) +
                                                    "Z"
                                                : null,
                                            biltyType: _biltyType ?? "",
                                            isFreight: _isFreight ?? false,
                                            freight: _freight != null &&
                                                    _freight != ""
                                                ? int.parse(_freight ?? "")
                                                : null,
                                            billtyCharges:
                                                _billtyCharges != null &&
                                                        _billtyCharges != ""
                                                    ? int.parse(
                                                        _billtyCharges ?? "")
                                                    : null,
                                            totalAmount: _totalAmount != null &&
                                                    _totalAmount != ""
                                                ? int.parse(_totalAmount ?? "")
                                                : null,
                                            advance: _advance != null &&
                                                    _advance != ""
                                                ? int.parse(_advance ?? "")
                                                : null,
                                            // gstAmount: _gstAmount != null &&
                                            //     _gstAmount != ""
                                            //     ? int.parse(_gstAmount ?? "")
                                            //     : null,
                                            grandTotal: _grandTotal != null &&
                                                    _grandTotal != ""
                                                ? int.parse(_grandTotal ?? "")
                                                : null,
                                            billTo: _billTo ?? "",
                                            receiverName: _receiverName ?? "",
                                            receiverContact:
                                                _receiverContact ?? "",
                                            remarks: _remarks ?? "",
                                            createdTime: null,
                                            lastUpdatedTime: null,
                                            netWeight: _netWeight ?? "",
                                            grossWeight: _grossWeight ?? "",
                                            createdBy: null,
                                          );
                                          print(bilty.toJson());
                                          if (kDebugMode) {
                                            print(bilty.toJson());
                                          }
                                          if (widget.bilty == null) {
                                            var result = await backendAPI
                                                .addBilty(bilty);
                                            if (result != false) {
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BiltyDetails(
                                                          bilty: result),
                                                ),
                                              );
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
                                                .updateBilty(bilty);
                                            if (result != false &&
                                                result != null) {
                                              Navigator.pop(context, true);
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
      },
    );
  }
}
