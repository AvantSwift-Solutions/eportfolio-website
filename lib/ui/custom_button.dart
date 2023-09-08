import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Text text;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = 60.0, // Default width
    this.height = 40.0, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 0, 0, 0), // Navy blue color
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Sharp rectangle shape
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            decorationColor: Colors.white, // White text color
            fontSize: 20,
            fontFamily: 'Cormorant Garamond', // Use the specified font
            fontWeight: FontWeight.w400,
          ),
        ),
        child: text,
      ),
    );
  }
}
