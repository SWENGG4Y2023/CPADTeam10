import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/constants.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/screens/bilty/bilty_form.dart';
import 'package:transport_bilty_generator/screens/hireChallan/hireChallan_form.dart';
import 'package:transport_bilty_generator/widgets/quick_action_button.dart';

class Home extends StatefulWidget {
  final dynamic accountDetails;

  const Home({Key? key, this.accountDetails}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    //getting window size
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomNavBarHeight = MediaQuery.of(context).padding.bottom;
    final double screenHeight = MediaQuery.of(context).size.height -
        (statusBarHeight + bottomNavBarHeight);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textScaleFactor = MediaQuery.of(context).textScaleFactor;

    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        decoration: const BoxDecoration(
          color: kPrimaryColorLight,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: screenHeight * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "home_screen_title".tr,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        widget.accountDetails.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                  kIsWeb
                      ? const SizedBox(
                          width: 100,
                          height: 100,
                          child: Icon(
                            Icons.business,
                            size: 100,
                          ),
                        )
                      : ClipRRect(
                          child: Image.network(
                            widget.accountDetails.company.logoURL,
                            fit: BoxFit.scaleDown,
                            width: 100.0,
                            height: 100.0,
                          ),
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                width: screenWidth - 52,
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                    )
                  ],
                  color: Colors.white,
                  border: const Border(
                    left: BorderSide(color: kPrimaryColor),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 8),
                      child: Text(
                        "quick_actions".tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const Divider(),
                    Center(
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              buildQuickActionsButtons(
                                  screenWidth, "create_bilty".tr, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BiltyForm(
                                        bilty: null,
                                        screenHeight: screenHeight,
                                    ),
                                  ),
                                );
                              }, Icons.add_box_outlined),
                              buildQuickActionsButtons(
                                  screenWidth, "create_challan".tr, () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const HireChallanForm(
                                        hireChallan: null),
                                  ),
                                );
                              }, Icons.article_rounded),
                              buildQuickActionsButtons(
                                  screenWidth, "generate_invoice".tr, () {
                                Navigator.pushNamed(
                                    context, "/generateInvoice");
                              }, Icons.add_card_rounded),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildQuickActionsButtons(
                                  screenWidth, "view_all_lr".tr, () {
                                Navigator.pushNamed(context, "/viewAllBilty");
                              }, Icons.article_rounded),
                              buildQuickActionsButtons(
                                  screenWidth, "view_all_challan".tr, () {
                                Navigator.pushNamed(
                                    context, "/viewAllHireChallan");
                              }, Icons.feed_rounded),
                              buildQuickActionsButtons(
                                  screenWidth, "view_all_bills".tr, () {
                                Navigator.pushNamed(context, "/viewAllInvoice");
                              }, Icons.feed_rounded),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Container(
                width: screenWidth - 52,
                height: screenHeight * 0.25,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                    )
                  ],
                  color: Colors.white,
                  border: const Border(
                    left: BorderSide(color: kPrimaryColor),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 8),
                      child: Text(
                        "other_actions".tr,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const Divider(),
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              buildQuickActionsButtons(
                                  screenWidth, "resources".tr, () {
                                Navigator.pushNamed(context, "/addResources");
                              }, Icons.add_to_photos_rounded),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
