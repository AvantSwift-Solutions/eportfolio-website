import 'package:avantswift_portfolio/controllers/view_controllers/technical_skills_controller.dart';
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:avantswift_portfolio/ui/tskill_image.dart';
import 'package:flutter/material.dart';

import '../ui/custom_texts/public_view_text_styles.dart';

class TechnicalSkillsWidget extends StatefulWidget {
  final TechnicalSkillsController? controller;
  const TechnicalSkillsWidget({Key? key, this.controller}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalSkillsWidgetState createState() => _TechnicalSkillsWidgetState();
}

class _TechnicalSkillsWidgetState extends State<TechnicalSkillsWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  late TechnicalSkillsController _technicalSkillsController;
  List<Image> allSurroundingImages = [];
  Image? centreImage;

  @override
  void initState() {
    super.initState();
    _technicalSkillsController =
        widget.controller ?? TechnicalSkillsController(TSkillRepoService());
    _loadImages();
  }

  void _loadImages() async {
    allSurroundingImages =
        await _technicalSkillsController.getTechnicalSkillImages();
    centreImage = await _technicalSkillsController.getCentralImage();
    // Ensure that the widget rebuilds after loading the images
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 800;
    double technicalSkillsWidth =
        isMobileView ? screenWidth * 0.75 : screenWidth * 0.4;
    double technicalSkillsHeight =
        isMobileView ? screenWidth * 0.78 : screenWidth * 0.4;
    double titleFontSize =
        isMobileView ? screenWidth * 0.05 : screenWidth * 0.02;
    double generalPadding =
        isMobileView ? screenWidth * 0.01 : screenWidth * 0.006;
    double leftPadding = 
        isMobileView ? screenWidth * 0.07 : screenWidth * 0.04;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // above title space
        SizedBox(
          height: generalPadding,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
              // padding: EdgeInsets.only(left: 0),
            Text(
              'Technical Skills',
              style: PublicViewTextStyles.generalSubHeading.copyWith(
                fontSize: titleFontSize,
              ),
              textAlign: TextAlign.start,
            ),
            // ),
            // title underline width
            // Padding(
              // padding: EdgeInsets.only(left: leftPadding),
            SizedBox(
              width: titleFontSize * 12,
              child: const Divider(
                color: Colors.black,
                thickness: 2.0,
              ),
            ),
            // ),
          ],
        ),
        // gap between title and images
        const SizedBox(
          height: 0,
        ),
        // main content
        SizedBox(
          width: technicalSkillsWidth,
          height: technicalSkillsHeight, // Adjust the height as needed
          child: SizedBox(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemCount: (allSurroundingImages.length / 8).ceil(),
              itemBuilder: (context, pageIndex) {
                int maxImagesPerPage = (allSurroundingImages.length /
                        (allSurroundingImages.length / 8).ceil())
                    .ceil();
                final startIndex = pageIndex * maxImagesPerPage;
                final endIndex = (startIndex + maxImagesPerPage)
                    .clamp(0, allSurroundingImages.length);
                final pageImages =
                    allSurroundingImages.sublist(startIndex, endIndex);
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: 55,
                      bottom: 20,
                      right: 1,
                      left: 1,
                      // Adjust this value to lower the image
                      child: Center(
                        child: TSkillsImage(
                          centerImage:
                              centreImage!, // Replace with your center image
                          allSurroundingImages: pageImages,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        // Expanded(
        //   child: Center(
        //     child:
        // Page Indicator

        Visibility(
          visible: (allSurroundingImages.length / 8).ceil() > 1,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                (allSurroundingImages.length / 8).ceil(),
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
          //   ),
          // ),
        ),
      ],
    );
  }
}
