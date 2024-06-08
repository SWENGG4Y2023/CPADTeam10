import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/invoice.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';

class InvoiceDownloadDialog extends StatefulWidget {
  final Invoice invoice;

  const InvoiceDownloadDialog({Key? key, required this.invoice})
      : super(key: key);

  @override
  State<InvoiceDownloadDialog> createState() => _InvoiceDownloadDialogState();
}

class _InvoiceDownloadDialogState extends State<InvoiceDownloadDialog> {
  final SharedPref prefs = SharedPref();
  Dio dio = Dio();

  //startDownload
  void startDownloading() async {
    String url =
        "https://backend.agltransport.in/invoice/downloadInvoicePdf?invoiceId=${widget.invoice.id}";
    var token = await prefs.getStringDataFromKey("token");
    String lrNumber = widget.invoice.invoiceNumber!.replaceAll("/", "-");
    String filename = "${lrNumber}.pdf";
    String path =
        await _getFilePath(filename, widget.invoice.company!.nameInitials);
    print("$url ${lrNumber} $filename $path");
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      await dio
          .download(url, path,
              options: Options(headers: {
                "Authorization": "Bearer $token",
                'Content-Type': 'application/json',
                'Accept': '*/*',
                'Connection': 'keep-alive'
              }),
              // cancelToken: cancelToken ?? CancelToken(),
              //     onReceiveProgress: (recievedBytes, totalBytes) {
              //   setState(() {
              //     progress = recievedBytes / totalBytes;
              //   });
              // }
              deleteOnError: true)
          .whenComplete(() {
        Navigator.pop(context);
        openFile(path);
      });
    }
    Navigator.pop(context, false);
  }

  var _openResult = 'Unknown';

  Future<void> openFile(String path) async {
    final result = await OpenFile.open(path);
    setState(() {
      _openResult = "type=${result.type}  message=${result.message}";
    });
  }

  Future<String> _getFilePath(String filename, String companyInitials) async {
    var dir = Directory("/storage/emulated/0/Download/$companyInitials");
    if (await dir.exists()) {
      return "${dir.path}/$filename";
    } else {
      dir.create(recursive: true);
      return "${dir.path}/$filename";
    }
  }

  @override
  void initState() {
    super.initState();
    startDownloading();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Downloading ",
            style: TextStyle(
              fontSize: 17,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
