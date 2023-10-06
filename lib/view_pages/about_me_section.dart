import 'package:avantswift_portfolio/dto/about_me_section_dto.dart';
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

  late AboutMeSectionDTO aboutMeData;
  late String _imageURL;
  bool _dataLoaded = false;

  @override
  void initState() {
    super.initState();
    _aboutMeSectionController =
        widget.controller ?? AboutMeSectionController(UserRepoService());
    _loadData();
  }

  Future<void> _loadData() async {
    aboutMeData = (await _aboutMeSectionController.getAboutMeSectionData())!;
    if (aboutMeData.imageURL?.isEmpty ?? false) {
      final replacementURL = await getReplacementURL();
      if (replacementURL.isNotEmpty) {
        aboutMeData.imageURL = replacementURL;
      }
    }

    setState(() {
      _imageURL = aboutMeData.imageURL ?? Constants.replaceImageURL;
      _dataLoaded = true;
    });
  }

  Future<String> getReplacementURL() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(Constants.replaceImageURL);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final screenWidth = constraints.maxWidth;
        bool isMobileView = screenWidth <= 600;
        double titleFontSize = screenWidth * 0.05;
        double descriptionFontSize = screenWidth * 0.01;
        double imageSize = isMobileView ? screenWidth * 0.8 : screenWidth * 0.4;

        // Check if it's a wide screen (desktop/tablet) or not (mobile)
        if (!isMobileView) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Flex(
                direction: Axis.horizontal,
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
                          padding: EdgeInsets.only(right: screenWidth * 0.15),
                          child: Text(
                            _dataLoaded
                                ? (aboutMeData.aboutMe ?? 'Default Description')
                                : 'Loading...',
                            style:
                                PublicViewTextStyles.generalBodyText.copyWith(
                              fontSize: descriptionFontSize * 2,
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
                      padding: const EdgeInsets.only(left: 0),
                      child: Image.network(
                        _dataLoaded ? _imageURL : Constants.replaceImageURL,
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A Bit About Myself...',
                    style: PublicViewTextStyles.generalHeading.copyWith(
                      fontSize: titleFontSize * 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(right: 0),
                    child: Text(
                      _dataLoaded
                          ? (aboutMeData.aboutMe ?? 'Default Description')
                          : 'Loading...',
                      style: PublicViewTextStyles.generalBodyText.copyWith(
                        fontSize: descriptionFontSize * 2.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 0),
                    child: Image.network(
                      _dataLoaded ? _imageURL : Constants.replaceImageURL,
                      width: imageSize,
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
