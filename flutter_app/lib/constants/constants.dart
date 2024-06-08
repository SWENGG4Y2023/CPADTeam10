import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

const textInputDecoration = InputDecoration(
  labelStyle: TextStyle(
    color: Colors.black,
    fontSize: 14,
  ),
  border: OutlineInputBorder(
    gapPadding: 2,
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      width: 2,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
  ),
  errorMaxLines: 3,
);

final textInputStyle = GoogleFonts.openSans(
  color: Colors.black,
);

final textLabelStyle = GoogleFonts.openSans(
  color: Colors.black,
);

const containerHeadingStyle = TextStyle(
  fontWeight: FontWeight.bold,
  height: 1.2,
);

const Color kButtonYellowColorLight = Color(0xFFFCA311);
const Color kCardShadowColorLight = Color.fromRGBO(252, 163, 17, 0.10);
const Color kRecentBillBackgroundColor = Color.fromARGB(3, 252, 163, 17);
const Color kPrimaryColor = Color(0xFFFCA311);
// const Color kPrimaryColorLight = Color(0xFFFDFFFC);
const Color kPrimaryColorLight = Color(0xFFFDFFFC);
BoxDecoration containerDecoration = BoxDecoration(
  borderRadius: const BorderRadius.only(
    topLeft: Radius.circular(16),
    topRight: Radius.circular(16),
    bottomLeft: Radius.circular(16),
    bottomRight: Radius.circular(16),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 3,
    )
  ],
  color: Colors.white,
);

BoxDecoration singleBorderedContainerDecoration = BoxDecoration(
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 3,
    )
  ],
  color: Colors.white,
  // border: Border(
  //   left: BorderSide(color: kPrimaryColor),
  // ),
  gradient: new LinearGradient(
      stops: [0.005, 0.005], colors: [kPrimaryColor, Colors.white]),
  borderRadius: BorderRadius.all(Radius.circular(12)),
);
BoxDecoration redOutlineContainerDecoration = BoxDecoration(
    border: Border.all(color: kPrimaryColor),
    borderRadius: const BorderRadius.all(Radius.circular(20)));
ModalBottomSheetProps modalBottomSheetProps = const ModalBottomSheetProps(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)),
  ),
);

const TextStyle blackColoredText = TextStyle(
  color: Colors.black,
);

String? convertDateTimeToString(DateTime dateTime) {
  return DateFormat("yyyy-MM-ddTHH:mm:ss.ms").format(dateTime) + "Z";
}
