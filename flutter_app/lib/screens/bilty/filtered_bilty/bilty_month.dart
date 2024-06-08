import "package:flutter/material.dart";
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_card.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/empty_placeholder.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class BiltyFilteredMonth extends StatefulWidget {
  const BiltyFilteredMonth({Key? key}) : super(key: key);

  @override
  State<BiltyFilteredMonth> createState() => _BiltyFilteredMonthState();
}

class _BiltyFilteredMonthState extends State<BiltyFilteredMonth> {
  late Future<dynamic> futureBilty;
  final BackendAPI backendAPI = BackendAPI();
  @override
  void initState() {
    futureBilty = backendAPI.getThisMonthBilty();
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
    return SingleChildScrollView(
      child: FutureBuilder<dynamic>(
        future: futureBilty,
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Loading();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Column(children: [
                  snapshot.data!.length != 0
                      ? ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, i) {
                            Bilty bilty = snapshot.data![i];
                            return BiltyCard(
                                bilty: bilty,
                                textScaleFactor: textScaleFactor,
                                screenHeight: screenHeight,
                                screenWidth: screenWidth);
                          },
                        )
                      : EmptyPlaceholder(),
                ]);
              } else {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("Network Error has Occurred"),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            futureBilty = backendAPI.getThisMonthBilty();
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
                            futureBilty = backendAPI.getThisMonthBilty();
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
  }
}
