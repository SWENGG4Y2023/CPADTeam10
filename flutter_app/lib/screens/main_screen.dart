import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/screens/home.dart';
import 'package:transport_bilty_generator/screens/settings.dart';
import 'package:transport_bilty_generator/services/backendAPI.dart';
import 'package:transport_bilty_generator/widgets/loading.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  //selectedIndex
  int _selectedIndex = 0;

  // function when tapping item
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  dynamic accountDetails;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return Scaffold(
        //Main Code
        body: FutureBuilder<dynamic>(future: () async {
          BackendAPI backendAPI = BackendAPI();
          return await backendAPI.getAccountDetails();
        }(), builder: (context, snapshot) {
          if (snapshot.hasData) {
            accountDetails = snapshot.data;
            return SafeArea(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  Home(accountDetails: accountDetails),
                  SettingsScreen(accountDetails: accountDetails),
                ],
              ),
            );
          } else {
            return const Center(
              child: Loading(),
            );
          }
        }),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFCA311).withOpacity(0.1),
                spreadRadius: 0,
                blurRadius: 18,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFFFFFFFF),
            selectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            elevation: 8,
            onTap: _onItemTapped,
            currentIndex: _selectedIndex,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFFFCA311),
              size: 30,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: "",
              ),
            ],
          ),
        ),
      );
    });
  }
}
