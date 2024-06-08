import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:transport_bilty_generator/constants/app_constants.dart';
import 'package:transport_bilty_generator/constants/theme.dart';
import 'package:transport_bilty_generator/controllers/language_controller.dart';
import 'package:transport_bilty_generator/screens/bilty/view_all_bilty.dart';
import 'package:transport_bilty_generator/screens/driver/view_drivers.dart';
import 'package:transport_bilty_generator/screens/hireChallan/view_all_challan.dart';
import 'package:transport_bilty_generator/screens/invoice/generate_invoice.dart';
import 'package:transport_bilty_generator/screens/invoice/view_all_invoice.dart';
import 'package:transport_bilty_generator/screens/main_screen.dart';
import 'package:transport_bilty_generator/screens/login.dart';
import 'package:transport_bilty_generator/screens/customer/view_all_customer.dart';
import 'package:transport_bilty_generator/screens/resources.dart';
import 'package:transport_bilty_generator/screens/splash_screen.dart';
import 'package:transport_bilty_generator/screens/vehicle/view_vehicles.dart';
import 'package:transport_bilty_generator/services/message.dart';
import 'package:transport_bilty_generator/services/dep.dart' as dep;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //getting language data
  Map<String, Map<String, String>> _languages = await dep.init();
  runApp(MyApp(
    languages: _languages,
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key,
    required this.languages,
  }) : super(key: key);
  final Map<String, Map<String, String>> languages;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LocalizationController>(
        builder: (localizationController) {
      return GetMaterialApp(
        theme: lightThemeData(context),
        debugShowCheckedModeBanner: false,
        home: SplashScreenPage(),
        //localization delegates
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // supported locales
        locale: localizationController.locale,
        fallbackLocale: Locale(
          AppConstants.languages[0].languageCode,
          AppConstants.languages[0].countryCode,
        ),
        translations: Messages(languages: widget.languages),
        routes: {
          "/home": (context) => const MainScreen(),
          "/login": (context) => const LogIn(),
          "/viewCustomers": (context) => const ViewCustomers(),
          "/viewDrivers": (context) => const ViewDrivers(),
          "/viewVehicles": (context) => const ViewVehicles(),
          "/addResources": (context) => const AddResources(),
          "/viewAllBilty": (context) => const ViewAllBilty(),
          "/viewAllHireChallan": (context) => const ViewAllHireChallan(),
          "/viewAllInvoice": (context) => const ViewAllInvoice(),
          "/generateInvoice": (context) => const GenerateInvoice(),
        },
      );
    });
  }
}
