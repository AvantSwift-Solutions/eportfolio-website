import 'package:flutter/material.dart';

class AdminViewDialogStyles {
  static const double _titleSize = 28;
  static const double _bodySize = 20;

  static const double listSpacing = 8;
  static const double closeIconSize = 35;
  static const double imageWidth = 170;
  static const int textBoxLines = 5;

  static const double listDialogWidth = 400;
  static const double listDialogHeight = 300;
  static const double showDialogWidth = 600;
  static const double showDialogHeight = 600;
  static const double reorderDialogWidth = 500;
  static const double reorderDialogHeight = 300;
  // Delete dialog width and height fits content

  static const Color bgColor = Color.fromARGB(255, 209, 240, 255);
  static const Color buttonColor = Color.fromARGB(255, 251, 244, 183);

  static SizedBox interTitleField = const SizedBox(height: 4);
  static SizedBox spacer = const SizedBox(height: 24);

  static ThemeData dialogThemeData = ThemeData(
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: errorTextStyle,
    ),
    dialogTheme: const DialogTheme(
      titleTextStyle: TextStyle(
        fontSize: _titleSize,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        fontSize: _bodySize,
        fontWeight: FontWeight.normal,
      ),
      backgroundColor: bgColor
    ),
    dividerTheme: const DividerThemeData(
      thickness: 1.5,
      color: Colors.black,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
      size: 30,
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black,
    )
  );

  static ButtonStyle elevatedButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
  );

  static ButtonStyle textButtonStyle = ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
  );

  static ButtonStyle imageButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
    padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 6)),
    iconColor: MaterialStateProperty.all<Color>(Colors.black),
  );

  static ButtonStyle noImageButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
    padding: MaterialStateProperty.all<EdgeInsets>(
        const EdgeInsets.symmetric(vertical: 16, horizontal: 6)),
    iconColor: MaterialStateProperty.all<Color>(Colors.black),
  );

  static TextStyle titleTextStyle = const TextStyle(
    fontSize: _titleSize,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle buttonTextStyle = const TextStyle(
    fontSize: _bodySize,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle listTextStyle = const TextStyle(
    fontSize: _bodySize,
  );

  static TextStyle errorTextStyle = const TextStyle(
    fontSize: _bodySize*0.8,
    fontWeight: FontWeight.normal,
    color: Colors.red,
  );

  static TextStyle inputTextStyle = const TextStyle(fontSize: _bodySize);

  /// Style specifically for the message '* indicates required field'
  static TextStyle indicatesTextStyle = const TextStyle(
      fontSize: _bodySize * (0.9), fontWeight: FontWeight.normal);

  static EdgeInsets titleDialogPadding =
      const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0);

  static EdgeInsets contentDialogPadding =
      const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0);

  static EdgeInsets actionsDialogPadding =
      const EdgeInsets.only(top: 0, left: 24, right: 24, bottom: 0);

  static EdgeInsets deleteActionsDialogPadding =
      const EdgeInsets.only(bottom: 12, left: 16, right: 16);

  static EdgeInsets titleContPadding = const EdgeInsets.only(top: 24);
  static EdgeInsets actionsContPadding =
      const EdgeInsets.only(top: 4, bottom: 24);

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

  /// Decoration for date selection input field
  static InputDecoration dateDecoration = const InputDecoration(
    prefixIcon: Icon(Icons.calendar_month),
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

  /// Decoration for the 'Other' text field in a drop down
  static InputDecoration otherDecoration = const InputDecoration(
    hintText: 'Enter a custom employment type',
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
