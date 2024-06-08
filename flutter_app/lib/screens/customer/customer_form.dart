import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/address.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';

class CustomerForm extends StatefulWidget {
  final Customer? customer;
  final double screenHeight;

  const CustomerForm(
      {Key? key, required this.customer, required this.screenHeight})
      : super(key: key);

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  // setting up all the controllers
  String _customerName = '';
  String _panNo = '';
  String _gstNo = '';
  String _email = '';
  List _addressExpFields = [];
  String? _country = "INDIA";
  String? _countryName = "INDIA";

  bool isCountryIndia = true;
  List<TextEditingController> _addressControllers = [];
  List<TextEditingController> _cityControllers = [];
  List<TextEditingController> _stateControllers = [];
  List<TextEditingController> _zipCodeControllers = [];
  List<TextEditingController> _phoneNoControllers = [];
  List<TextFormField> _phoneNoFields = [];

  @override
  void dispose() {
    for (final controller in _phoneNoControllers) {
      controller.dispose();
    }
    for (int i = 0; i < _addressControllers.length; i++) {
      _addressControllers[i].dispose();
      _cityControllers[i].dispose();
      _stateControllers[i].dispose();
      _zipCodeControllers[i].dispose();
    }
    super.dispose();
  }

  // widget to add phone tiles
  Widget _addTilePhone() {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return IconButton(
            icon: const CircleAvatar(
              child: Icon(Icons.add, color: Colors.white, size: 24),
              backgroundColor: Colors.black,
            ),
            onPressed: () {
              final controller = TextEditingController();
              final field = TextFormField(
                validator: (val) {
                  return val!.isEmpty == true ? "enter_mobile_number".tr : null;
                },
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: controller,
                decoration: textInputDecoration.copyWith(
                    labelText:
                    "mobile_number".tr + " ${_phoneNoFields.length + 1}"),
              );
              setState(() {
                _phoneNoControllers.add(controller);
                _phoneNoFields.add(field);
              });
            },
          );
        });
  }

  // widget to remove phone tiles
  Widget _removeTilePhone() {
    return IconButton(
      icon: const CircleAvatar(
        child: Icon(Icons.remove, color: Colors.white, size: 18),
        backgroundColor: Colors.black,
      ),
      onPressed: () {
        setState(() {
          _phoneNoControllers.removeLast();
          _phoneNoFields.removeLast();
        });
      },
    );
  }

  // widget for listview of phone times
  Widget _listViewPhone(double screenWidth) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(7),
        shrinkWrap: true,
        itemCount: _phoneNoFields.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Center(
              child: _phoneNoFields[index],
            ),
          );
        });
  }

  // widget to add AddressExpTile
  Widget _addExpAddressField(double screenHeight) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return IconButton(
            onPressed: () {
              final addressController = TextEditingController();
              final cityController = TextEditingController();
              final stateController = TextEditingController();
              final zipCodeController = TextEditingController();
              final field = ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: false,
                  ),
                  header: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                        "address".tr + " ${_addressExpFields.length + 1}",
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
                        textInputDecoration.copyWith(labelText: "address".tr),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: addressController,
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      // City
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        decoration:
                        textInputDecoration.copyWith(labelText: "city".tr),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: cityController,
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      //State
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        decoration:
                        textInputDecoration.copyWith(labelText: "state".tr),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        controller: stateController,
                      ),
                      SizedBox(
                        height: screenHeight * 0.01,
                      ),
                      // Zip Code
                      TextFormField(
                        textCapitalization: TextCapitalization.characters,
                        keyboardType: TextInputType.number,
                        decoration:
                        textInputDecoration.copyWith(labelText: "zipcode".tr),
                        controller: zipCodeController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  expanded: const SizedBox());
              setState(() {
                _addressExpFields.add(field);
                _addressControllers.add(addressController);
                _cityControllers.add(cityController);
                _zipCodeControllers.add(zipCodeController);
                _stateControllers.add(stateController);
              });
            },
            icon: const CircleAvatar(
              child: Icon(Icons.add, color: Colors.white, size: 24),
              backgroundColor: Colors.black,
            ),
          );
        });
  }

  // remove Address Exp Tile
  Widget _removeAddressExpTile() {
    return IconButton(
        onPressed: () {
          setState(() {
            _stateControllers.removeLast();
            _zipCodeControllers.removeLast();
            _addressControllers.removeLast();
            _cityControllers.removeLast();
            _addressExpFields.removeLast();
          });
        },
        icon: const CircleAvatar(
          child: Icon(Icons.remove, color: Colors.white, size: 24),
          backgroundColor: Colors.black,
        ));
  }

  Widget _listViewAddressExpTile() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _addressControllers.length,
      itemBuilder: (context, index) {
        return Container(
            margin: const EdgeInsets.only(bottom: 5, top: 5),
            child: _addressExpFields[index]);
      },
    );
  }

  // function to preset the value for the variables
  void prefillForm(Customer? customer, double screenHeight) {
    if (customer != null) {
      _customerName = customer.name;
      _panNo = customer.pan;
      _gstNo = customer.gstIn ?? "";
      _email = customer.email;
      isCountryIndia = customer.country == "INDIA" ? true : false;
      _countryName = customer.country != null
          ? isCountryIndia
          ? customer.country
          : customer.country!.substring(8)
          : null;

      _country = isCountryIndia ? "INDIA" : "OTHER";
      _phoneNoControllers = List.generate(customer.phone.length,
              (index) => TextEditingController(text: customer.phone[index]));
      _addressControllers = List.generate(
          customer.address.length,
              (index) =>
              TextEditingController(text: customer.address[index].address));
      _cityControllers = List.generate(customer.address.length,
              (index) =>
              TextEditingController(text: customer.address[index].city));
      _stateControllers = List.generate(
          customer.address.length,
              (index) =>
              TextEditingController(text: customer.address[index].state));
      _zipCodeControllers = List.generate(
          customer.address.length,
              (index) =>
              TextEditingController(
                  text: customer.address[index].zipCode.toString()));

      _phoneNoFields = List.generate(
          customer.phone.length,
              (index) =>
              TextFormField(
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.black,
                ),
                controller: _phoneNoControllers[index],
                decoration: textInputDecoration.copyWith(
                    labelText: "mobile_number".tr + " ${index + 1}"),
              ));
      _addressExpFields = List.generate(
          customer.address.length,
              (index) =>
              GetBuilder<LocalizationController>(
                  builder: (localizationControoler) {
                    return ExpandablePanel(
                        theme: const ExpandableThemeData(
                          headerAlignment: ExpandablePanelHeaderAlignment
                              .center,
                          tapBodyToCollapse: false,
                        ),
                        header: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text("address".tr + " ${index + 1}",
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
                                  labelText: "address".tr),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _addressControllers[index],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            //City
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "city".tr),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _cityControllers[index],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            //State
                            TextFormField(
                              decoration: textInputDecoration.copyWith(
                                  labelText: "state".tr),
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                              controller: _stateControllers[index],
                            ),
                            SizedBox(
                              height: screenHeight * 0.01,
                            ),
                            // Zip code
                            TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: textInputDecoration.copyWith(
                                  labelText: "zipcode".tr),
                              controller: _zipCodeControllers[index],
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        expanded: const SizedBox());
                  }));
    }
  }

  @override
  void initState() {
    super.initState();
    prefillForm(widget.customer, widget.screenHeight);
  }

  bool _loading = false;

  // form Global Key
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //getting screen size
    final double statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    final double bottomNavBarHeight = MediaQuery
        .of(context)
        .padding
        .bottom;
    final double screenHeight = MediaQuery
        .of(context)
        .size
        .height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double textScaleFactor = MediaQuery
        .of(context)
        .textScaleFactor;

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
          return Scaffold(
            backgroundColor: kPrimaryColorLight,
            appBar: AppBar(
              title: Text(
                "add_customer".tr,
                style: TextStyle(
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
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 20),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //Customer Name
                          TextFormField(
                            keyboardType: TextInputType.name,
                            textCapitalization: TextCapitalization.characters,
                            initialValue: _customerName,
                            onChanged: (val) {
                              setState(() {
                                _customerName = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: "customer_name".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          RadioListTile(
                            title: const Text(
                              "INDIA",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            value: "INDIA",
                            groupValue: _country,
                            onChanged: (value) {
                              setState(() {
                                _country = value.toString();
                                isCountryIndia = true;
                                _countryName = value.toString();
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          RadioListTile(
                            title: const Text(
                              "OTHER",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            value: "OTHER",
                            groupValue: _country,
                            onChanged: (value) {
                              setState(() {
                                _country = value.toString();
                                isCountryIndia = false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                          isCountryIndia
                              ? const SizedBox()
                              : TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            decoration: textInputDecoration.copyWith(
                                labelText: "Country Name".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            initialValue: _countryName,
                            onChanged: (val) {
                              setState(() {
                                _countryName = "$_country - $val";
                              });
                            },
                          ),
                          isCountryIndia
                              ? const SizedBox()
                              : SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          // Pan No
                          isCountryIndia
                              ? TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            initialValue: _panNo,
                            onChanged: (val) {
                              setState(() {
                                _panNo = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: "pan_number".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                              : const SizedBox(),
                          isCountryIndia
                              ? SizedBox(
                            height: screenHeight * 0.015,
                          )
                              : const SizedBox(),
                          // GST No
                          isCountryIndia
                              ? TextFormField(
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            initialValue: _gstNo,
                            onChanged: (val) {
                              setState(() {
                                _gstNo = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: "gst_number".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                              : const SizedBox(),
                          isCountryIndia
                              ? SizedBox(
                            height: screenHeight * 0.015,
                          )
                              : const SizedBox(),
                          // Email
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            initialValue: _email,
                            onChanged: (val) {
                              setState(() {
                                _email = val;
                              });
                            },
                            decoration: textInputDecoration.copyWith(
                                labelText: "email_hintText".tr),
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(
                            height: screenHeight * 0.015,
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("mobile_number".tr,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Row(
                                  children: [
                                    _addTilePhone(),
                                    _removeTilePhone(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _listViewPhone(screenWidth),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("address".tr,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                Row(
                                  children: [
                                    _addExpAddressField(screenHeight),
                                    _removeAddressExpTile(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          _listViewAddressExpTile(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
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
                          List<Address> addressList = [];
                          for (int i = 0;
                          i < _addressControllers.length;
                          i++) {
                            Address address = Address(
                                id: 0,
                                address: _addressControllers[i].text,
                                city: _cityControllers[i].text,
                                state: _stateControllers[i].text,
                                zipCode:
                                int.parse(_zipCodeControllers[i].text));
                            addressList.add(address);
                          }
                          List phoneNoList = [];
                          for (int i = 0;
                          i < _phoneNoControllers.length;
                          i++) {
                            phoneNoList.add(_phoneNoControllers[i].text);
                          }
                          // Creating Customer class
                          Customer customer = Customer(
                              id: widget.customer?.id,
                              address: addressList,
                              email: _email,
                              gstIn: _gstNo,
                              name: _customerName,
                              pan: _panNo,
                              phone: phoneNoList,
                              country: _countryName);
                          // calling backend functions and adding the customer to db
                          BackendAPI backendAPI = BackendAPI();
                          print(customer.toJson());
                          if (widget.customer == null) {
                            var result =
                            await backendAPI.addCustomer(customer);
                            if (result) {
                              Navigator.pop(context, result);
                              Get.snackbar(
                                "success".tr,
                                "success_message_for_create".tr,
                                snackPosition: SnackPosition.BOTTOM,
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
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.black,
                                colorText: Colors.white,
                              );
                            }
                          } else {
                            var result =
                            await backendAPI.updateCustomer(customer);
                            if (result) {
                              Navigator.pop(context, result);
                              Get.snackbar(
                                "success".tr,
                                "success_message_for_update".tr,
                                snackPosition: SnackPosition.BOTTOM,
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
                                snackPosition: SnackPosition.BOTTOM,
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
                          valueColor: AlwaysStoppedAnimation<Color>(
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
        });
  }
}
