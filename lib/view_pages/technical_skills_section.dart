import 'package:avantswift_portfolio/controllers/view_controllers/technical_skills_controller.dart';
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:avantswift_portfolio/ui/tskill_image.dart';
import 'package:flutter/material.dart';

class TechnicalSkillsWidget extends StatefulWidget {
  const TechnicalSkillsWidget({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalSkillsWidgetState createState() => _TechnicalSkillsWidgetState();
}

class _TechnicalSkillsWidgetState extends State<TechnicalSkillsWidget> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  final TechnicalSkillsController _technicalSkillsController =
      TechnicalSkillsController(TSkillRepoService());
  List<Image> allSurroundingImages = [];
  Image? centreImage;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    allSurroundingImages =
        await _technicalSkillsController.getTechnicalSkillImagesGivenPage(1);
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
    return Column(
      children: [
        SizedBox(
          width: 400,
          height: 400, // Adjust the height as needed
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
                        )),
                  ],
                );
              },
            ),
          ),
        ),
        // Page Indicator
        Visibility(
          visible: (allSurroundingImages.length / 8).ceil() > 1,
          child: SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                (allSurroundingImages.length / 8).ceil(),
                (index) => Container(
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
      ],
    );
  }
}
