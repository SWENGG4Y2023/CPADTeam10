import 'dart:ui';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_bilty_generator/constants/app_constants.dart';
import 'package:transport_bilty_generator/models/language_model.dart';

class LocalizationController extends GetxController implements GetxService {
  final SharedPreferences sharedPreferences;

  //selection index
  int _selectedIndex = 0;
  //getter for selectionindex
  int get selectionIndex => _selectedIndex;

  LocalizationController({required this.sharedPreferences}) {
    loadCurrentLanguage();
  }
  //creating locale from appconstants[0]
  Locale _locale = Locale(AppConstants.languages[0].languageCode,
      AppConstants.languages[0].countryCode);
  Locale get locale => _locale;

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;
  void loadCurrentLanguage() async {
    // only gets called during installation or reboot
    _locale = Locale(
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
            AppConstants.languages[0].languageCode,
        sharedPreferences.getString(AppConstants.COUNTRY_CODE) ??
            AppConstants.languages[0].countryCode);

    //getting index of languagelocale model
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == _locale.languageCode) {
        _selectedIndex = index;
        break;
      }
    }
    _languages = [];
    _languages.addAll(AppConstants.languages);
    update();
  } // loadCurrentLanguage

  // method of setting language
  void setLangugae(Locale locale) {
    Get.updateLocale(locale);
    _locale = locale;
    saveLanguage(_locale);
    update();
  }

  void setSelectIndex(int index) {
    _selectedIndex = index;
    update();
  }

  void saveLanguage(Locale locale) async {
    sharedPreferences.setString(
        AppConstants.LANGUAGE_CODE, locale.languageCode);
    sharedPreferences.setString(AppConstants.COUNTRY_CODE, locale.countryCode!);
  }

  Future<int> getCurrentLanguageIndex() async {
    String language_code =
        sharedPreferences.getString(AppConstants.LANGUAGE_CODE) ??
            AppConstants.languages[0].languageCode;
    if (language_code == "en") {
      return 0;
    } else {
      return 1;
    }
  }
}
