import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class CustomMenuButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;

  const CustomMenuButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  _CustomMenuButtonState createState() => _CustomMenuButtonState();
}

class _CustomMenuButtonState extends State<CustomMenuButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.hovered)) {
              return Colors.black; // Set the text color to black when hovered
            } else {
              return PublicViewTextStyles.navBarText.color!; // Use specified color when not hovered
            }
          }),
        ),
        child: Text(
          widget.text,
          style: PublicViewTextStyles.navBarText,
        ),
      ),
    );
  }
}
