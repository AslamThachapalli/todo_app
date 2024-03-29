import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/theme_provider.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final light = ThemeData(
    backgroundColor: Colors.white,
    colorSchemeSeed: primaryClr,
    brightness: Brightness.light,
  );

  static final dark = ThemeData(
    backgroundColor: darkGreyClr,
    colorSchemeSeed: darkGreyClr,
    brightness: Brightness.dark,
  );
}

TextStyle subHeadingStyle(BuildContext context) {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Provider.of<ThemeProvider>(context).isLightMode
          ? Colors.grey
          : Colors.grey[400],
    ),
  );
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  );
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
  );
}

TextStyle subTitleStyle(BuildContext context) {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Provider.of<ThemeProvider>(context).isLightMode
          ? Colors.grey[600]
          : Colors.grey[100],
    ),
  );
}
