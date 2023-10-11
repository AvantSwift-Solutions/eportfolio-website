// ignore_for_file: prefer_const_constructors

import 'package:avantswift_portfolio/dto/section_keys_dto.dart';
import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/custom_menu_button.dart';

class MenuSection extends StatefulWidget {
  final Function(GlobalKey) scrollToSection;
  final SectionKeysDTO sectionKeys; // Map to store section keys
  static const double dividerThickness = 1.0;
  static const double dividerIndent = 60.0;
  static const double dividerEndDent = 60.0;
  static const double leftPadding = 20.0;
  static const double rightPadding = 20.0;
  static const double firstItemLeftPadding = 50.0;
  static const double sizedBoxSize = 20.0;

  const MenuSection({
    super.key,
    required this.scrollToSection,
    required this.sectionKeys, // Accept the map of section keys
  });

  @override
  MenuSectionState createState() => MenuSectionState();
}

class MenuSectionState extends State<MenuSection> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double calculatedFontSize = screenWidth < 750 ? screenWidth * 0.03 : screenWidth * 0.035;

    return Column(
      children: [
        Divider(
          color: Colors.black,
          thickness: MenuSection.dividerThickness,
          indent: MenuSection.dividerIndent,
          endIndent: MenuSection.dividerEndDent,
        ),
        SizedBox(height: MenuSection.sizedBoxSize),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MenuSection.firstItemLeftPadding,
                  right: MenuSection.rightPadding),
              child: TextButton(
                onPressed: () {
                  widget.scrollToSection(widget.sectionKeys.experience);
                },
                style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                }),
                ),
                child: Text(
                  "Experience",
                  style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize))
              )
            ),
            Text(
              '/',
              style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MenuSection.leftPadding,
                  right: MenuSection.rightPadding),
              child: TextButton(
                onPressed: () {
                  widget.scrollToSection(widget.sectionKeys.skillsEdu);
                },
                style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                }),
                ),
                child: Text(
                  "Skills & Education",
                  style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize))
              ),
            ),
            Text(
              '/',
              style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: MenuSection.leftPadding,
                  right: MenuSection.rightPadding),
              child: TextButton(
                onPressed: () {
                  widget.scrollToSection(widget.sectionKeys.projects);
                },
                style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                }),
                ),
                child: Text(
                  "Projects",
                  style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize))
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: MenuSection.firstItemLeftPadding,
                  right: MenuSection.rightPadding),
              child: TextButton(
                onPressed: () {
                  widget.scrollToSection(widget.sectionKeys.awardsCerts);
                },
                style: ButtonStyle(
                        overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return Colors.transparent;
                }),
                ),
                child: Text(
                  "Awards, Certifications & Peer Recommendations",
                  style: PublicViewTextStyles.navBarText.copyWith(fontWeight: FontWeight.normal, fontSize: calculatedFontSize))
              ),
            ),
          ],
        ),
        SizedBox(height: MenuSection.sizedBoxSize),
        Divider(
          color: Colors.black,
          thickness: MenuSection.dividerThickness,
          indent: MenuSection.dividerIndent,
          endIndent: MenuSection.dividerEndDent,
        ),
      ],
    );
  }
}
