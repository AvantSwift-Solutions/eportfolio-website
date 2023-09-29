import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../controllers/view_controllers/about_me_section_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class AboutMeSection extends StatefulWidget {
  final AboutMeSectionController? controller;

  const AboutMeSection({Key? key, this.controller}) : super(key: key);

  @override
  AboutMeSectionState createState() => AboutMeSectionState();
}

class AboutMeSectionState extends State<AboutMeSection> {
  late AboutMeSectionController _aboutMeSectionController;
  String? _aboutMe;
  String? _imageURL;

  @override
  void initState() {
    super.initState();
    _aboutMeSectionController =
        widget.controller ?? AboutMeSectionController(UserRepoService());

    // Load data in initState
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final aboutMeSectionData =
          await _aboutMeSectionController.getAboutMeSectionData();

      setState(() {
        _aboutMe = aboutMeSectionData?.aboutMe;
        _imageURL = aboutMeSectionData?.imageURL;
      });
    } catch (e) {
      // Handle errors, e.g., display an error message
      log('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_aboutMe == null || _imageURL == null) {
      // Data is still loading or an error occurred
      return const Center(child: CircularProgressIndicator());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.05;
    double descriptionFontSize = screenWidth * 0.01;
    double spacing = screenWidth * 0.15;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          // Use Row for side-by-side layout
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A Bit About Myself...',
                    style: PublicViewTextStyles.generalHeading.copyWith(
                      fontSize: titleFontSize * 0.8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.only(right: spacing),
                    child: Text(
                      _aboutMe ?? 'Default Description',
                      style: PublicViewTextStyles.generalBodyText.copyWith(
                        fontSize: descriptionFontSize * 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(left: 100.0),
                child: Image.network(
                  _imageURL ?? Constants.replaceImageURL,
                  width: 200,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
