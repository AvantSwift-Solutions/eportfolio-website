import 'package:flutter/material.dart';

class AdminViewDialogStyles {
  static const double _titleSize = 28;
  static const double _bodySize = 20;

  static const double listDialogWidth = 400;
  static const double showDialogWidth = 500;
  static const double reorderDialogWidth = 500;
  // Delete dialog width fits content

  static SizedBox interTitleField = const SizedBox(height: 4);
  static SizedBox spacer = const SizedBox(height: 24);

  static ThemeData dialogThemeData = ThemeData(
    dialogTheme: const DialogTheme(
        titleTextStyle: TextStyle(
          fontSize: _titleSize,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          fontSize: _bodySize,
          fontWeight: FontWeight.normal,
        ),
        backgroundColor: Color.fromARGB(255, 209, 240, 255)),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Colors.black,
    ),
  );

  static ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
        const Color.fromARGB(255, 251, 244, 183)),
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: _bodySize,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle listTextStyle = const TextStyle(
    fontSize: _bodySize,
  );

  static TextStyle inputTextStyle = const TextStyle(fontSize: _bodySize);

  /// Style specifically for the message '* indicates required field'
  static TextStyle indicatesTextStyle =
      const TextStyle(fontSize: _bodySize * (0.8));

  static EdgeInsets contentPadding = const EdgeInsets.only(left: 24, right: 24);

  static EdgeInsets actionPadding =
      const EdgeInsets.only(bottom: 12, left: 16, right: 16);

  static InputDecoration inputDecoration = const InputDecoration(
    filled: true,
    fillColor: Colors.white,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.black,
        width: 1.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(
        color: Colors.red,
        width: 1.0,
      ),
    ),
  );
}
