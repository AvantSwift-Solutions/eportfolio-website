import 'dart:math';

import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/dto/section_keys_dto.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter_svg/svg.dart';
import 'search_section.dart'; // Import your SearchSection widget here

class HeaderSection extends StatelessWidget {
  static const double menuIconWidth = 30.0;
  static const double menuIconHeight = 30.0;
  final Function(GlobalKey) scrollToSection;
  final SectionKeysDTO sectionKeys;

  const HeaderSection({
    Key? key,
    required this.scrollToSection,
    required this.sectionKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isScreenSmall = screenWidth < 250;
    final isSmallForMenu = screenWidth < 570;

    Widget searchSection = SearchSection(
      sectionKeys: sectionKeys,
      scrollToSection: scrollToSection,
      width: min(screenWidth * 0.4, 170),
    );

    if (isScreenSmall) {
      searchSection = const SizedBox(
        width: 0,
        height: 0,
      ); // Replace with an empty SizedBox when hidden
    }

    Widget menuButton = TextButton(
      onPressed: () {
        scrollToSection(sectionKeys.menu);
      },
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      child: SvgPicture.asset(
        'assets/menu-navigation.svg', // Provide the path to your SVG image file
        width:
            menuIconWidth, // Set the width and height as per your requirements
        height: menuIconHeight,
      ),
    );
    if (isSmallForMenu) {
      menuButton = const SizedBox(
        width: 0,
        height: 0,
      ); // Replace with an empty SizedBox when hidden
    }

    return SliverAppBar(
      backgroundColor: const Color.fromRGBO(253, 252, 255, 1.0),
      pinned: true,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Align to the start and end
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Visibility(
              visible: !isScreenSmall, // Hide the styledLogo on small screens
              child: PublicViewTextStyles.styledLogo(
                size: min(screenWidth * 0.07, 42),
              ),
            ),
          ),
          Expanded(
            child: isScreenSmall
                ? searchSection
                : Align(
                    alignment: Alignment.centerRight, // Right-align the search
                    child: searchSection,
                  ),
          ),
          menuButton, // Use the conditionally defined menuButton widget
        ],
      ),
    );
  }
}
