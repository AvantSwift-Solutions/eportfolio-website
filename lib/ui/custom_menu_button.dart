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
  CustomMenuButtonState createState() => CustomMenuButtonState();
}

class CustomMenuButtonState extends State<CustomMenuButton> {
  bool isHovered = false;
  TextStyle textStyle =
      PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal);
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedFontSize =
        screenWidth < 750 ? screenWidth * 0.03 : screenWidth * 0.035;

    return MouseRegion(
      onEnter: (PointerEvent event) {
        setState(() {
          textStyle = PublicViewTextStyles.navBarText.copyWith(
              fontWeight: FontWeight.bold, fontSize: calculatedFontSize);
        });
      },
      onExit: (PointerEvent event) {
        setState(() {
          textStyle = PublicViewTextStyles.navBarText.copyWith(
              fontWeight: FontWeight.normal, fontSize: calculatedFontSize);
        });
      },
      child: TextButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            return Colors.transparent;
          }),
        ),
        child: Text(
          widget.text,
          style: textStyle.copyWith(fontSize: calculatedFontSize),
        ),
      ),
    );
  }
}
