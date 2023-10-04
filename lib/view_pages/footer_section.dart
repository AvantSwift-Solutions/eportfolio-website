import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/custom_menu_button.dart';

class FooterSection extends StatelessWidget {
  static const double dividerThickness = 1.0;
  static const double verticalPadding = 20;
  final Function(GlobalKey) scrollToSection;
  final Map<String, GlobalKey> sectionKeys;

  const FooterSection({
    Key? key,
    required this.scrollToSection,
    required this.sectionKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Divider(
          color: Color(0xFFBABAB3),
          thickness: dividerThickness,
        ),
        Container(
          color: const Color.fromRGBO(253, 252, 255, 1.0),
          padding: const EdgeInsets.symmetric(vertical: verticalPadding),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: PublicViewTextStyles.styledLogo(),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: CustomMenuButton(
                    onPressed: () {
                      scrollToSection(sectionKeys['landing_page']!);
                    },
                    text: "Back to the Top",
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
