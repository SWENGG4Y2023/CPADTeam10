import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/models/bilty.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_card.dart';
import 'package:transport_bilty_generator/screens/bilty/filtered_bilty/bilty_month.dart';
import 'package:transport_bilty_generator/screens/bilty/filtered_bilty/bilty_thisWeek.dart';
import 'package:transport_bilty_generator/screens/bilty/filtered_bilty/bilty_today.dart';
import 'package:transport_bilty_generator/screens/bilty/filtered_bilty/bilty_yesterday.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class ViewAllBilty extends StatefulWidget {
  const ViewAllBilty({Key? key}) : super(key: key);

  @override
  State<ViewAllBilty> createState() => _ViewAllBiltyState();
}

class _ViewAllBiltyState extends State<ViewAllBilty>
    with TickerProviderStateMixin {
  late Future<dynamic> futureBilty;
  final BackendAPI backendAPI = BackendAPI();
  @override
  void initState() {
    futureBilty = backendAPI.getAllBilty();

    super.initState();
    tabController = TabController(vsync: this, length: 5, initialIndex: 1);
  }

  @override
  void dispose() {
    searchController.dispose();
    tabController.dispose();
    super.dispose();
  }

  // form Global Key
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  late TabController tabController;
  final pageViewController = PageController(
    initialPage: 1,
  );

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double screenWidth = MediaQuery.of(context).size.width;

    String _searchText = '';

    return GetBuilder<LocalizationController>(
      builder: (localizationController) {
        return DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                "view_all_lr".tr,
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
              actions: [
                IconButton(
                  icon: Icon(Icons.refresh_sharp),
                  onPressed: () {
                    setState(() {
                      futureBilty = backendAPI.getAllBilty();
                      searchController.clear();
                    });
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(screenHeight * 0.13),
                child: Column(
                  children: [
                    TabBar(
                      controller: tabController,
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(color: Colors.white, width: 2.0),
                        insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 10.0),
                      ),
                      tabs: const [
                        Tab(
                          text: "All",
                        ),
                        Tab(
                          text: "Today",
                        ),
                        Tab(
                          text: "Yesterday",
                        ),
                        Tab(
                          text: "Week",
                        ),
                        Tab(
                          text: "Month",
                        ),
                      ],
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: kPrimaryColorLight,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10)),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 5),
                          child: Row(
                            children: [
                              Expanded(
                                  child: TextFormField(
                                controller: searchController,
                                validator: (val) {
                                  return val!.isEmpty == true
                                      ? "Enter a Value".tr
                                      : null;
                                },
                                onTap: () {
                                  setState(() {
                                    tabController.index = 0;
                                  });
                                },
                                onChanged: (val) {
                                  _searchText = val;
                                },
                                onFieldSubmitted: (val) {
                                  if (_formKey.currentState!.validate()) {
                                    _searchText = searchController.text;
                                    setState(() {
                                      futureBilty = backendAPI
                                          .getBiltyBySearch(_searchText);
                                    });
                                  }
                                },
                                style: blackColoredText,
                                decoration: const InputDecoration(
                                  labelText: "Search By LR or Consigner Name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                ),
                              )),
                              IconButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      futureBilty = backendAPI
                                          .getBiltyBySearch(_searchText);
                                    });
                                  }
                                },
                                icon: const Icon(Icons.search),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: TabBarView(
              controller: tabController,
              children: [
                // all bilty
                SingleChildScrollView(
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                                  : Center(
                                      child: Column(
                                        children: const [
                                          Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text("No Bilty Found"),
                                          ),
                                        ],
                                      ),
                                    ),
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
                                        futureBilty = backendAPI.getAllBilty();
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
                                        futureBilty = backendAPI.getAllBilty();
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
                // today bilty
                BiltyFilteredToday(),
                BiltyFilteredYesterday(),
                BiltyFilteredWeek(),
                BiltyFilteredMonth(),
              ],
            ),
          ),
        );
      },
    );
  }
}
