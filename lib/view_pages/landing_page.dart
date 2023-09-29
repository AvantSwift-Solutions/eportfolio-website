import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../controllers/view_controllers/landing_page_controller.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_view_button.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class LandingPage extends StatefulWidget {
  final Function scrollToBottom;

  const LandingPage({super.key, required this.scrollToBottom});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final LandingPageController _landingPageController =
      LandingPageController(UserRepoService());

  late String _name;
  late String _nickname;
  late String _imageURL;
  late String _landingPageDescription;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final landingPageData = await _landingPageController.getLandingPageData();

    if (landingPageData != null) {
      setState(() {
        _name = landingPageData.name!;
        _nickname = landingPageData.nickname!;
        _imageURL =
            landingPageData.imageURL ?? 'https://example.com/default_image.jpg';
        _landingPageDescription =
            landingPageData.landingPageDescription ?? 'Default Description';
      });
    } else {
      // Handle the case where data couldn't be loaded
    }
  }

  Future<String> getReplacementURL() async {
    final storage = FirebaseStorage.instance;
    final ref = storage.ref().child(Constants.replaceImageURL);
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    if (_nickname == null || _name == null) {
      // Data is still loading or an error occurred
      return const Center(child: CircularProgressIndicator());
    }

    // final landingPageData = snapshot.data;
    final screenWidth = MediaQuery.of(context).size.width;

    double titleFontSize = screenWidth * 0.05;
    double descriptionFontSize = screenWidth * 0.015;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
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
                          text: _name,
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
                          text: _nickname,
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
                          text: _landingPageDescription,
                        ),
                      ])),
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
                  _imageURL,
                  width: 300,
                  height: 600,
                  fit: BoxFit.cover,
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
                  color: Colors.black, // Divider color
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
                  height: 200, // Adjust the height of the divider as needed
                  width: 1.0, // Width of the vertical divider
                  color: Colors.black, // Divider color
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
