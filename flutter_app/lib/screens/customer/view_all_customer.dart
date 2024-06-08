import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/customer.dart';
import 'package:transport_bilty_generator/screens/customer/customer_form.dart';
import 'package:transport_bilty_generator/screens/customer/view_customer_details.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/delete_confirmation.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class ViewCustomers extends StatefulWidget {
  const ViewCustomers({Key? key}) : super(key: key);

  @override
  State<ViewCustomers> createState() => _ViewCustomersState();
}

class _ViewCustomersState extends State<ViewCustomers> {
  late Future<List<dynamic>?> futureCustomer;

  BackendAPI backendAPI = BackendAPI();

  @override
  void initState() {
    futureCustomer = backendAPI.getAllCustomers();
    super.initState();
  }

  //get list_customer_names from customer list
  List<String> getListCustomerNames(List<dynamic> list_customer) {
    if (list_customer != null) {
      // to be deleted later
      List<String> list_customer_names = [];
      for (int i = 0; i < list_customer.length; i++) {
        list_customer_names.add(list_customer[i].name);
      }
      return list_customer_names;
    } else {
      return [];
    }
  }

  final dropdownKey = GlobalKey<DropdownSearchState>();

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColor,
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () async {
            var result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CustomerForm(
                          customer: null,
                          screenHeight: screenHeight,
                        )));
            if (result == true) {
              setState(() {
                futureCustomer = backendAPI.getAllCustomers();
              });
            }
          },
        ),
        appBar: AppBar(
          title: Text(
            "customer".tr,
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
        body: SingleChildScrollView(
          child: FutureBuilder<List?>(
              future: futureCustomer,
              builder: (context, AsyncSnapshot<List?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const Loading();
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return Container(
                        margin: EdgeInsets.only(bottom: screenHeight * 0.15),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: Column(
                          children: [
                            // DropdownSearch<dynamic>(
                            //   key: dropdownKey,
                            //   dropdownDecoratorProps:
                            //       DropDownDecoratorProps(
                            //           dropdownSearchDecoration:
                            //               textInputDecoration.copyWith(
                            //                   labelText: "Customer".tr)),
                            //   items: snapshot.data!,
                            //   itemAsString: (customer) => customer.name,
                            //   popupProps: PopupProps.modalBottomSheet(
                            //     showSearchBox: true,
                            //     itemBuilder: (context, item, isSelected) {
                            //       return Text(
                            //         item.name,
                            //         style: TextStyle(color: Colors.black),
                            //       );
                            //     },
                            //     searchFieldProps: TextFieldProps(
                            //       style: TextStyle(color: Colors.black),
                            //       decoration: InputDecoration(),
                            //     ),
                            //   ),
                            //   onChanged: (val) async {
                            //     // using the searchCustomer method here to get the customer details
                            //     // and forwarding to the customer Page
                            //     var result = await Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (context) =>
                            //               CustomerCard(customer: val)),
                            //     );
                            //     if (result == true) {
                            //       setState(() {
                            //         futureCustomer =
                            //             backendAPI.getAllCustomers();
                            //       });
                            //     }
                            //   },
                            // ),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, i) {
                                Customer customer = snapshot.data![i];
                                return Slidable(
                                  key: ValueKey(i),
                                  endActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    children: [
                                      SlidableAction(
                                        onPressed: (context) async {
                                          var result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CustomerForm(
                                                        customer: customer,
                                                        screenHeight:
                                                            screenHeight,
                                                      )));
                                          if (result == true) {
                                            setState(() {
                                              futureCustomer =
                                                  backendAPI.getAllCustomers();
                                            });
                                          }
                                        },
                                        backgroundColor: kPrimaryColor,
                                        foregroundColor: Colors.white,
                                        icon: Icons.edit,
                                        label: "Edit",
                                      ),
                                      SlidableAction(
                                        onPressed: (context) async {
                                          final result = await showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  DeleteDialogBox(
                                                    titleText: customer.name,
                                                    deleteItem: "Customer",
                                                    deleteObject: customer,
                                                  ));
                                          if (result == true) {
                                            backendAPI
                                                .deleteCustomer(customer.id!)
                                                .whenComplete(() {
                                              setState(() {
                                                futureCustomer = backendAPI
                                                    .getAllCustomers();
                                              });
                                            });
                                          }
                                        },
                                        backgroundColor: Colors.red,
                                        foregroundColor: Colors.white,
                                        icon: Icons.delete,
                                        label: 'Delete',
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: containerDecoration,
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: ListTile(
                                      onTap: () async {
                                        var result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomerCard(
                                                      customer: customer)),
                                        );
                                        if (result == true) {
                                          setState(() {
                                            futureCustomer =
                                                backendAPI.getAllCustomers();
                                          });
                                        }
                                      },
                                      title: Text(
                                        customer.name,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      subtitle: Text(
                                        customer.gstIn.toString().toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      trailing: customer.country != null
                                          ? Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration:
                                                  redOutlineContainerDecoration
                                                      .copyWith(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                              child: Text(
                                                "${customer.country}",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(),
                                      leading: const Icon(
                                        Icons.person,
                                        color: kPrimaryColor,
                                        size: 36,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Network Error has Occurred"),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    futureCustomer =
                                        backendAPI.getAllCustomers();
                                  });
                                },
                                icon: const Icon(Icons.cached),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  default:
                    if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    } else if (snapshot.hasData) {
                      return Text("${snapshot.data}");
                    } else {
                      return Scaffold(
                        body: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text("Network Error has Occurred"),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    futureCustomer =
                                        backendAPI.getAllCustomers();
                                  });
                                },
                                icon: const Icon(Icons.cached),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                }
              }),
        ),
      );
    });
  }
}
