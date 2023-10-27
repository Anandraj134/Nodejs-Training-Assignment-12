// Import the necessary package and class.
import 'package:assignment_12/core/app_export.dart';
import 'package:google_fonts/google_fonts.dart';

// Define a class for managing app styles.
class AppStyle {
  // Define a static method for text form field styles.
  static textFormFieldStyle({
    double fontSize = 18,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    // Return a style using the Google Fonts 'Signika Negative' font.
    return GoogleFonts.getFont(
      'Signika Negative',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static h1Style({
    double fontSize = 24,
    Color color = AppColor.primaryColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    // Return a style using the Google Fonts 'Signika Negative' font.
    return GoogleFonts.getFont(
      'Signika Negative',
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}