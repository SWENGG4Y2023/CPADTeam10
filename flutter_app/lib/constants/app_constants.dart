import 'package:transport_bilty_generator/models/language_model.dart';

class AppConstants {
  //localization data

  static const String COUNTRY_CODE = 'country_code';
  static const String LANGUAGE_CODE = 'language_code';

  static List<LanguageModel> languages = [
    LanguageModel(
        countryCode: "US", languageCode: "en", languageName: "English"),
    LanguageModel(countryCode: "IN", languageCode: "hi", languageName: "Hindi"),
  ];
}
