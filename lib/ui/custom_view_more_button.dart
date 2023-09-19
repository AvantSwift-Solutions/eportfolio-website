import 'package:flutter/material.dart';

class CustomViewMoreButton extends StatefulWidget {
  // final Function(bool) onStateChanged;
  final VoidCallback onPressed;
  final bool initialValue;

  CustomViewMoreButton({
    // required this.onStateChanged,
    required this.onPressed,
    required this.initialValue,
  });

  @override
  _CustomViewMoreButtonState createState() => _CustomViewMoreButtonState();
}

class _CustomViewMoreButtonState extends State<CustomViewMoreButton> {
  bool isPressed = false;

  @override
  void initState() {
    super.initState();
    isPressed = widget.initialValue; // Initialize the button state
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isPressed = !isPressed; // Toggle the button state
          // widget.onStateChanged(isPressed); // Call the state change callback
          widget.onPressed(); // Call the onPressed callback
        });
      },
      child: Icon(
        isPressed
            ? Icons.keyboard_double_arrow_up_rounded
            : Icons.keyboard_double_arrow_down_rounded,
        size: 40.0, // Adjust the size as needed
        color: Colors.black, // Customize the arrow color
      ),
    );
  }
}
