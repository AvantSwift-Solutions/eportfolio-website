// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/custom_menu_button.dart';

class MenuSection extends StatefulWidget {
  final Function(GlobalKey) scrollToSection;
  final Map<String, GlobalKey> sectionKeys; // Map to store section keys

  const MenuSection({
    required this.scrollToSection,
    required this.sectionKeys, // Accept the map of section keys
  });

  @override
  MenuSectionState createState() => MenuSectionState();
}

class MenuSectionState extends State<MenuSection> {

  @override
  Widget build(BuildContext context) {

    return Column (
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0, right: 20.0),
              child: CustomMenuButton(
                onPressed: () {
                          widget.scrollToSection(widget.sectionKeys['landing']!);
                        }, // Set onPressed to null for Button 1
                text: "Experience",
              ),
            ),
            Text(
              '/',
              style: PublicViewTextStyles.navBarText,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomMenuButton(
                onPressed: () {
                          widget.scrollToSection(widget.sectionKeys['contact']!);
                        }, // Set onPressed to null for Button 1
                text: "Skills & Education",
              ),
            ),
            Text(
              '/',
              style: PublicViewTextStyles.navBarText,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomMenuButton(
                onPressed: () {
                          widget.scrollToSection(widget.sectionKeys['experience']!);
                        }, // Set onPressed to null for Button 1
                text: "Projects",
              ),
            ),
          ],  
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0, right: 20.0),
              child: CustomMenuButton(
                onPressed: () {
                          widget.scrollToSection(widget.sectionKeys['experience']!);
                        }, // Set onPressed to null for Button 1
                text: "Awards & Certifications",
              ),
            ),
            Text(
              '/',
              style: PublicViewTextStyles.navBarText,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: CustomMenuButton(
                onPressed: () {
                          widget.scrollToSection(widget.sectionKeys['experience']!);
                        }, // Set onPressed to null for Button 1
                text: "Recommendations",
              ),
            ),
          ],
        ),
      ],
    );
  }
}