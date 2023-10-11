// text_styles.dart
import 'package:flutter/material.dart';

class PublicViewTextStyles {
  static Widget styledLogo({double size = 42}) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Steven. ',
            style: TextStyle(
              color: Colors.black, // Color for "Steven."
              fontSize: size,
              fontFamily: 'Montserrat',
            ),
          ),
          TextSpan(
            text: 'Zhou',
            style: TextStyle(
              color: const Color(0xFFFBC9A7), // Color for "Zhou"
              fontSize: size,
              fontFamily: 'Montserrat',
            ),
          ),
        ],
      ),
    );
  }

  static TextStyle generalHeading = const TextStyle(
    fontSize: 54,
    fontWeight: FontWeight.w500,
    letterSpacing: (-2.2) / 100,
    color: Color(0xFF1E1E1E),
    fontFamily: 'Montserrat',
  );

  static TextStyle generalSubHeading = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: (-1.1) / 100,
    fontFamily: 'Roboto',
    color: Color(0xFF1E1E1E),
  );

  static TextStyle generalBodyText = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: (-1.1) / 100,
    fontFamily: 'Lato',
    color: Color(0xFF1E1E1E),
  );

  static TextStyle navBarText = const TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.normal,
    letterSpacing: (-2.2) / 100,
    fontFamily: 'Montserrat',
    color: Colors.black,
  );

  static TextStyle buttonText = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    letterSpacing: (-2.2) / 100,
    fontFamily: 'Roboto',
    color: Color(0xFFFFFFFF),
  );

  static TextStyle aboutMeBodyText =
      generalBodyText.copyWith(fontSize: 20, fontWeight: FontWeight.normal);

  static TextStyle professionalExperienceHeading =
      generalSubHeading.copyWith(fontSize: 40, color: const Color(0xFFE6AA68));

  static TextStyle professionalExperienceSubHeading =
      generalSubHeading.copyWith(fontSize: 24, color: const Color(0xFFE6AA68));

  static TextStyle educationBasicInfo =
      generalSubHeading.copyWith(fontSize: 14);

  static TextStyle educationDescription =
      generalBodyText.copyWith(fontSize: 12);

  static TextStyle personalProjectName =
      generalSubHeading.copyWith(fontSize: 20);
}
