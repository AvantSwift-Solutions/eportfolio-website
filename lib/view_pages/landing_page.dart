import 'dart:developer';

import 'package:avantswift_portfolio/dto/landing_page_dto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../controllers/view_controllers/landing_page_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_view_button.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class LandingPage extends StatefulWidget {
  final Function scrollToBottom;
  final LandingPageController? controller;

  const LandingPage({super.key, required this.scrollToBottom, this.controller});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late LandingPageController _landingPageController;
  String? imageURL;
  LandingPageDTO? landingPageData;
  int buttonRequirementWidth = 325;
  @override
  void initState() {
    super.initState();
    _landingPageController =
        widget.controller ?? LandingPageController(UserRepoService());
    // Fetch the landing page data in initState
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      landingPageData = await _landingPageController.getLandingPageData();
      if (landingPageData != null) {
        if (landingPageData!.imageURL == null ||
            landingPageData!.imageURL!.isEmpty) {
          final replacementURL = await _getReplacementURL();
          if (replacementURL.isNotEmpty) {
            landingPageData!.imageURL = replacementURL;
          }
        }

        // Update the state with the loaded data
        if (mounted) {
          setState(() {
            imageURL = landingPageData!.imageURL;
          });
        }
      }
    } catch (error) {
      log('Error loading data: $error');
    }
  }

  Future<String> _getReplacementURL() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(Constants.replaceImageURL);
    final url = await ref.getDownloadURL();
    return url;
  }

  Future<String> getReplacementURL() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(Constants.replaceImageURL);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // double titleFontSize = screenWidth * 0.025;
    // double descriptionFontSize = screenWidth * 0.15;

    // Determine if the screen width is smaller than a certain threshold (e.g., 600).
    bool isSmallScreen = screenWidth < 1140;
    double titleFontSize = 80;
    double descriptionFontSize = 30;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: isSmallScreen
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: PublicViewTextStyles.generalHeading.copyWith(
                          // fontSize: titleFontSize,//
                          ),
                      children: [
                        const TextSpan(
                          text: 'Hey there, \nI\'m ',
                        ),
                        TextSpan(
                          text: '${landingPageData?.name} ',
                          style: const TextStyle(
                            color: Color(0xffe6aa68),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const TextSpan(
                          text: 'but you \ncan call me ',
                        ),
                        TextSpan(
                          text: '${landingPageData?.nickname}',
                          style: const TextStyle(
                            color: Color(0xffe6aa68),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const TextSpan(
                          text: '.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      style: PublicViewTextStyles.generalBodyText.copyWith(
                          // fontSize: descriptionFontSize,
                          ),
                      children: [
                        const WidgetSpan(
                          child: SizedBox(
                            width: 55,
                            height: 25,
                            child: Divider(
                              color: Colors.black,
                              thickness: 2,
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: '     ',
                        ),
                        TextSpan(
                          text: landingPageData?.landingPageDescription ??
                              'Default Description',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (screenWidth > buttonRequirementWidth)
                    CustomViewButton(
                      text: 'Get in touch',
                      onPressed: () {
                        widget.scrollToBottom();
                      },
                    ),
                  const SizedBox(height: 20),
                  Center(
                    child: Image.network(
                      landingPageData?.imageURL ?? Constants.replaceImageURL,
                      width: 300,
                      height: 200,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: PublicViewTextStyles.generalHeading.copyWith(
                              fontSize: titleFontSize,
                            ),
                            children: [
                              const TextSpan(
                                text: 'Hey there, \nI\'m ',
                              ),
                              TextSpan(
                                text: '${landingPageData?.name} ',
                                style: const TextStyle(
                                  color: Color(0xffe6aa68),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const TextSpan(
                                text: 'but you \ncan call me ',
                              ),
                              TextSpan(
                                text: '${landingPageData?.nickname}',
                                style: const TextStyle(
                                  color: Color(0xffe6aa68),
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                              const TextSpan(
                                text: '.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            style:
                                PublicViewTextStyles.generalBodyText.copyWith(
                              fontSize: descriptionFontSize,
                            ),
                            children: [
                              const WidgetSpan(
                                child: SizedBox(
                                  width: 55,
                                  height: 25,
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 2,
                                  ),
                                ),
                              ),
                              const TextSpan(
                                text: '     ',
                              ),
                              TextSpan(
                                text: landingPageData?.landingPageDescription ??
                                    'Default Description',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        CustomViewButton(
                          text: 'Get in touch',
                          onPressed: () {
                            widget.scrollToBottom();
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Image.network(
                        landingPageData?.imageURL ?? Constants.replaceImageURL,
                        width: 300,
                        height: 300,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 40),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 300,
                        width: 1.0,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 20),
                      const RotatedBox(
                        quarterTurns: 1,
                        child: Text(
                          'Scroll down to learn more about me',
                          style: TextStyle(
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 200,
                        width: 1.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
