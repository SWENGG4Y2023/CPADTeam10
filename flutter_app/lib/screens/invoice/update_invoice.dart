import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import "package:transport_bilty_generator/constants/constants.dart";
import 'package:transport_bilty_generator/screens/invoice/view_invoice_details.dart';
import '../../controllers/language_controller.dart';
import '../../models/invoice.dart';
import '../../services/backendAPI.dart';

class UpdateInvoice extends StatefulWidget {
  Invoice invoice;

  UpdateInvoice({Key? key, required this.invoice}) : super(key: key);

  @override
  State<UpdateInvoice> createState() => _UpdateInvoiceState();
}

class _UpdateInvoiceState extends State<UpdateInvoice> {
  final _formKey = GlobalKey<FormState>();

  final BackendAPI backendAPI = BackendAPI();

  DateTime? invoiceDate;

  String? voucherNumber;
  String? invoiceStatus;

  bool? isPaid;
  DateTime? paidDate;
  bool _loading = false;
  // function for getting date and time
  Future<void> _invoiceDateSelector(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: const ColorScheme(
                primary: kPrimaryColor,
                secondary: kPrimaryColor,
                surface: kPrimaryColor,
                background: kPrimaryColor,
                error: kPrimaryColor,
                onPrimary: Colors.black,
                onSecondary: Colors.black,
                onSurface: Colors.black,
                onBackground: Colors.black,
                onError: Colors.black,
                brightness: Brightness.light,
              ),
              dialogBackgroundColor: Colors.white,
            ),
            child: child!,
          );
        },
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

  void prefillForm(Invoice? invoice) {
    if (invoice != null) {
      invoiceDate = invoice.invoiceDate != null
          ? DateTime.parse(invoice.invoiceDate!)
          : null;
      voucherNumber = invoice.voucherNumber;
      invoiceStatus = invoice.invoiceStatus;
      isPaid = invoice.isPaid;
      paidDate = invoice.paidDate != null
          ? DateTime.parse(invoice.paidDate!)
          : null;
    }
  }

  @override
  void initState() {
    prefillForm(widget.invoice);
    super.initState();
  }

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
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "update_invoice".tr,
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
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    textCapitalization: TextCapitalization.characters,
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
                    textCapitalization: TextCapitalization.characters,
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.5)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "date".tr,
                          style: TextStyle(fontSize: textScaleFactor * 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(invoiceDate != null
                                ? DateFormat('dd-MM-yyyy').format(invoiceDate!)
                                : ""),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.black,
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
                  // isPaid
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "is_invoice_paid".tr,
                        style: TextStyle(fontSize: textScaleFactor * 16),
                      ),
                      Checkbox(
                        value: isPaid,
                        onChanged: (value) {
                          setState(() {
                            isPaid = value;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenHeight * 0.015,
                  ),
                  // paid date
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black.withOpacity(0.5)),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "invoice_paid_date".tr,
                          style: TextStyle(fontSize: textScaleFactor * 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(paidDate != null
                                ? DateFormat('dd-MM-yyyy').format(paidDate!)
                                : ""),
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                final DateTime? picked =
                                    await showDatePicker(
                                        builder: (context, child) {
                                          return Theme(
                                            data: ThemeData.light().copyWith(
                                              colorScheme: const ColorScheme(
                                                primary: kPrimaryColor,
                                                secondary: kPrimaryColor,
                                                surface: kPrimaryColor,
                                                background: kPrimaryColor,
                                                error: kPrimaryColor,
                                                onPrimary: Colors.black,
                                                onSecondary: Colors.black,
                                                onSurface: Colors.black,
                                                onBackground: Colors.black,
                                                onError: Colors.black,
                                                brightness: Brightness.light,
                                              ),
                                              dialogBackgroundColor:
                                                  Colors.white,
                                            ),
                                            child: child!,
                                          );
                                        },
                                        context: context,
                                        initialDate:
                                            paidDate ?? DateTime.now(),
                                        firstDate: DateTime(2015, 8),
                                        lastDate: DateTime(2101));
                                if (picked != null && picked != paidDate) {
                                  setState(() {
                                    paidDate = picked;
                                  });
                                }
                              },
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
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            "update_invoice".tr,
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
                                id: widget.invoice.id,
                                invoiceDate: invoiceDate != null
                                    ? DateFormat("yyyy-MM-ddTHH:mm:ss.ms")
                                            .format(invoiceDate!) +
                                        "Z"
                                    : null,
                                voucherNumber: voucherNumber,
                                invoiceStatus: invoiceStatus,
                                listHireChallan: null,
                                listBilty: null,
                                invoiceNumber: null,
                                invoiceValue: null,
                                suffixInvoiceNumber: null,
                                createdBy: null,
                                company: null,
                                createdTime: null,
                                customer: null,
                                isTaxTypeIgst: null,
                                gstPercentage: null,
                                sgst: null,
                                cgst: null,
                                igst: null,
                                otherChargesDescription: null,
                                otherChargesAmount: null,
                                isPaid: isPaid,
                                paidDate: paidDate != null
                                    ? DateFormat("yyyy-MM-ddTHH:mm:ss.ms")
                                            .format(paidDate!) +
                                        "Z"
                                    : null,
                              );
                              var result =
                                  await backendAPI.updateInvoice(invoice);
                              if (result != false &&
                                  result != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ViewInvoiceDetails(invoice: result),
                                  ),
                                );
                                Get.snackbar(
                                  "success".tr,
                                  "success_message_for_update".tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              } else {
                                Get.snackbar(
                                  "error".tr,
                                  "error_message_for_update".tr,
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.black,
                                  colorText: Colors.white,
                                );
                              }
                              setState(() {
                                _loading = false;
                              });
                            }
                          },
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
