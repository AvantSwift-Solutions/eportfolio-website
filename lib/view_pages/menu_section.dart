import 'package:flutter/material.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class MenuSection extends StatefulWidget {
  const MenuSection({super.key});

  @override
  MenuSectionState createState() => MenuSectionState();
}

class MenuSectionState extends State<MenuSection> {

  @override
  Widget build(BuildContext context) {

    return const Column (
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0, right: 20.0),
              child: ElevatedButton(
                onPressed: null, // Set onPressed to null for Button 1
                child: Text("Experience"),
              ),
            ),
            Text("/"),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                onPressed: null, // Set onPressed to null for Button 1
                child: Text("Skills & Education"),
              ),
            ),
            Text("/"),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                onPressed: null, // Set onPressed to null for Button 1
                child: Text("Projects"),
              ),
            ),
          ],  
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 50.0, right: 20.0),
              child: ElevatedButton(
                onPressed: null, // Set onPressed to null for Button 1
                child: Text("Awards & Certifications"),
              ),
            ),
            Text("/"),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: ElevatedButton(
                onPressed: null, // Set onPressed to null for Button 1
                child: Text("Recommendations"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}