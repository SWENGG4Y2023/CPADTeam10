import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/screens/invoice/invoice_card.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class ViewAllInvoice extends StatefulWidget {
  const ViewAllInvoice({Key? key}) : super(key: key);

  @override
  State<ViewAllInvoice> createState() => _ViewAllInvoiceState();
}

class _ViewAllInvoiceState extends State<ViewAllInvoice> {
  late Future<dynamic> futureInvoice;
  final BackendAPI backendAPI = BackendAPI();

  @override
  void initState() {
    futureInvoice = backendAPI.getAllInvoice();
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
            "view_all_invoice".tr,
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
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  futureInvoice = backendAPI.getAllInvoice();
                });
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
          ],
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<dynamic>(
            future: futureInvoice,
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Loading();
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        snapshot.data!.length != 0
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, i) {
                                  Invoice invoice = snapshot.data![i];
                                  return InvoiceCard(
                                      invoice: invoice,
                                      textScaleFactor: textScaleFactor,
                                      screenHeight: screenHeight,
                                      screenWidth: screenWidth);
                                },
                              )
                            : Center(
                                child: Column(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text("No Invoice Found"),
                                    ),
                                  ],
                                ),
                              ),
                      ],
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
                                futureInvoice = backendAPI.getAllInvoice();
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
                                futureInvoice = backendAPI.getAllInvoice();
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
        ),
      );
    });
  }
}
