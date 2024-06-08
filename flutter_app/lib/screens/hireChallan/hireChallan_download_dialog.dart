import 'dart:io';

import 'package:better_open_file/better_open_file.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/hireChallan.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';

class HireChallanDownloadDialog extends StatefulWidget {
  final HireChallan hireChallan;
  const HireChallanDownloadDialog({Key? key, required this.hireChallan})
      : super(key: key);

  @override
  State<HireChallanDownloadDialog> createState() =>
      _HireChallanDownloadDialogState();
}

class _HireChallanDownloadDialogState extends State<HireChallanDownloadDialog> {
  final SharedPref prefs = SharedPref();
  Dio dio = Dio();

  //startDownload
  void startDownloading() async {
    String url =
        "https://backend.agltransport.in/hireChallan/downloadHireChallanPdf?hireChallanId=${widget.hireChallan.id}";

    var token = await prefs.getStringDataFromKey("token");
    String lrNumber =
        widget.hireChallan.hireChallanNumber!.replaceAll("/", "-");
    String filename = "${lrNumber}.pdf";
    String path =
        await _getFilePath(filename, widget.hireChallan.company!.nameInitials);
    var status = await Permission.storage.status;

    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isGranted) {
      await dio
          .download(url, path,
              options: Options(headers: {"Authorization": "Bearer $token"}),
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
    Navigator.pop(context);
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
