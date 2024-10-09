import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  //
  ThemeData lightTheme() {
    return ThemeData(
      // fontFamily: GoogleFonts.ibmPlexSerif().fontFamily,
      // fontFamily: GoogleFonts.krub().fontFamily,
      // fontFamily: GoogleFonts.montserrat().fontFamily,
      // fontFamily: GoogleFonts.poppins().fontFamily,
      // fontFamily: GoogleFonts.roboto().fontFamily,
      fontFamily: GoogleFonts.poppins().fontFamily,
      // fontFamily: GoogleFonts.oswald().fontFamily,
      primarySwatch: AppColor.primaryMaterialColor,
      primaryColor: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
        cursorColor: AppColor.cursorColor,
      ),
      //backgroundColor: Colors.white,

      cardColor: Colors.white, // AppColor.background2,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      // brightness: Brightness.light,
      // CUSTOMIZE showDatePicker Colors
      dialogBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor!,
        secondary: AppColor.accentColor!,
        brightness: Brightness.light,
      ),
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      highlightColor: Colors.grey[400],
    );
  }

  ThemeData darkTheme() {
    return ThemeData(
      // fontFamily: GoogleFonts.ibmPlexSerif().fontFamily,
      // fontFamily: GoogleFonts.krub().fontFamily,
      // fontFamily: GoogleFonts.montserrat().fontFamily,
      fontFamily: GoogleFonts.poppins().fontFamily,
      primaryColor: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
        cursorColor: AppColor.cursorColor,
      ),
      cardColor: Colors.white, // AppColor.background2,
      textTheme: TextTheme(
        displaySmall: TextStyle(
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          color: Colors.black,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      // brightness: Brightness.light,
      // CUSTOMIZE showDatePicker Colors
      dialogBackgroundColor: Colors.white,
      buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
      highlightColor: Colors.grey[400],
      colorScheme: ColorScheme.light(
        primary: AppColor.primaryColor!,
        secondary: AppColor.accentColor!,
        brightness: Brightness.light,
      ),
    );
  }

//
/* ThemeData darkTheme() {
    return ThemeData(
      // fontFamily: GoogleFonts.iBMPlexSerif().fontFamily,
      // fontFamily: GoogleFonts.krub().fontFamily,
      // fontFamily: GoogleFonts.roboto().fontFamily,
      fontFamily: GoogleFonts.poppins().fontFamily,
      // fontFamily: GoogleFonts.notoSans().fontFamily,
      // fontFamily: GoogleFonts.oswald().fontFamily,
      // brightness: Brightness.dark,
      primarySwatch: AppColor.primaryMaterialColor,
      primaryColor: AppColor.primaryColor,
      primaryColorDark: AppColor.primaryColorDark,
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colors.grey,
        cursorColor: AppColor.cursorColor,
      ),
      backgroundColor: Colors.white,// Colors.grey[850],
      cardColor: Colors.white, //AppColor.background2,
      textTheme: TextTheme(
        headline3: TextStyle(
            color: Colors.black,
        ),
        bodyText1: TextStyle(
          color: Colors.black,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.black,
      ),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: AppColor.primaryColor,
        secondary: AppColor.accentColor,
        brightness: Brightness.dark,
      ),
    );
  } */
}
