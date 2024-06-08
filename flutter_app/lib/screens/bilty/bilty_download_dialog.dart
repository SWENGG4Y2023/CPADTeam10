import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/services/shared_pref.dart';
import 'package:better_open_file/better_open_file.dart';

class BiltyDownloadDialog extends StatefulWidget {
  final Bilty bilty;
  const BiltyDownloadDialog({Key? key, required this.bilty}) : super(key: key);

  @override
  State<BiltyDownloadDialog> createState() => _BiltyDownloadDialogState();
}

class _BiltyDownloadDialogState extends State<BiltyDownloadDialog> {
  final SharedPref prefs = SharedPref();
  Dio dio = Dio();
  double progress = 0.0;

  void startDownloading() async {
    String url =
        "https://backend.agltransport.in/bilty/downloadBiltyPdf?biltyId=${widget.bilty.id}";
    var token = await prefs.getStringDataFromKey("token");
    // String lrNumber = widget.bilty.lrNumber!.replaceAll('/', '-');
    // String filename = "$lrNumber.pdf";
    // String download_path = await _getFilePath(filename);
    // String path =
    //     download_path + "${widget.bilty.company?.nameInitials}/$filename";
    String lrNumber = widget.bilty.lrNumber!.replaceAll("/", "-");
    String filename = "${lrNumber}.pdf";
    String path =
        await _getFilePath(filename, widget.bilty.company!.nameInitials);
    // print(path);
    //asking for permission
    var status = await Permission.storage.status;
    print(status.toString());
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    await dio
        .download(url, path,
            options: Options(headers: {
              "Authorization": "Bearer $token",
              
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
