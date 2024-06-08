import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:intl/intl.dart";
import "package:transport_bilty_generator/constants/constants.dart";
import "package:transport_bilty_generator/models/invoice.dart";
import "package:transport_bilty_generator/services/backendAPI.dart";
import "package:transport_bilty_generator/widgets/snackbar.dart";

class InvoiceUpdateStatus extends StatefulWidget {
  final Invoice invoice;

  const InvoiceUpdateStatus({Key? key, required this.invoice})
      : super(key: key);

  @override
  State<InvoiceUpdateStatus> createState() => _InvoiceUpdateStatusState();
}

class _InvoiceUpdateStatusState extends State<InvoiceUpdateStatus> {
  String? invoiceStatus;
  bool loading = false;
  final BackendAPI backendAPI = BackendAPI();

  DateTime? invoiceDate;

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

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;

    return AlertDialog(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text("Update Invoice",
                style: TextStyle(fontSize: textScaleFactor * 16)),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                border: Border.all(color: kPrimaryColor),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
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
          TextFormField(
            decoration:
                textInputDecoration.copyWith(labelText: "Invoice Status"),
            initialValue: widget.invoice.invoiceStatus,
            onChanged: (val) {
              setState(() {
                invoiceStatus = val;
              });
            },
            keyboardType: TextInputType.text,
            style: const TextStyle(
              color: Colors.black,
            ),
            textCapitalization: TextCapitalization.characters,
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
                    IconButton(
                      style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(
                          Colors.black,
                        ),
                      ),
                      onPressed: () async =>
                          _invoiceDateSelector(context),
                      icon: const Icon(
                          Icons.calendar_month_outlined),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        "Update",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: loading
                    ? null
                    : () async {
                        if (invoiceStatus != null) {
                          setState(() {
                            loading = true;
                          });
                          var result = await backendAPI.updateInvoiceStatus(
                              widget.invoice, invoiceStatus!);
                          if (result != false && result != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                showSnackBar(
                                    "Invoice Status Updated Successfully"));
                            Navigator.pop(context, true);
                          } else {
                            setState(() {
                              loading = false;
                            });
                            ScaffoldMessenger.of(context)
                                .showSnackBar(showSnackBar("Error Occured"));
                          }
                        }
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
