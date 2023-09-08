import 'package:flutter/material.dart';

class CustomViewButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomViewButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        backgroundColor:
            const Color.fromRGBO(79, 147, 122, 1), // Customize the button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(width: 8), // Add space between text and arrow
          Image.asset(
            'send_view_button.png',
            width: 20,
            height: 50,
          ),
        ],
      ),
    );
  }
}
