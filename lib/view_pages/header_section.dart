import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class HeaderSection extends StatelessWidget {
  final Function(GlobalKey) scrollToSection;
  final Map<String, GlobalKey> sectionKeys;

  const HeaderSection({
    Key? key,
    required this.scrollToSection,
    required this.sectionKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: const Color.fromRGBO(253, 252, 255, 1.0),
      pinned: true,
      scrolledUnderElevation: 0,
      centerTitle: false,
      actions: [
        TextButton(
          onPressed: () {
            scrollToSection(sectionKeys['menu']!);
          },
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all(Colors.transparent),
          ),
          child: Text(
            'Menu',
            style: PublicViewTextStyles.buttonText.copyWith(color: const Color(0xff1E1E1E)),
          ),
        ),
      ],
      title: PublicViewTextStyles.styledLogo(),
    );
  }
}
