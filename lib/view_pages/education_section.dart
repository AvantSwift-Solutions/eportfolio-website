import 'package:flutter/material.dart';
import '../controllers/view_controllers/education_section_controller.dart';
import '../dto/education_section_dto.dart';
import '../reposervice/education_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/dashed_vertical_line_painter.dart';

import '../constants.dart';

class EducationSection extends StatefulWidget {
  final EducationSectionController? controller;
  const EducationSection({Key? key, this.controller}) : super(key: key);

  @override
  EducationSectionState createState() => EducationSectionState();
}

class EducationSectionState extends State<EducationSection> {
  late EducationSectionController _educationSectionController;

  List<EducationDTO> educationSectionData = [];
  int currentPage = 0;
  static const itemsPerPage = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _educationSectionController =
        widget.controller ?? EducationSectionController(EducationRepoService());
    _pageController = PageController();
    _loadEducationData();
  }

  Future<void> _loadEducationData() async {
    final data = await _educationSectionController.getEducationSectionData();
    setState(() {
      educationSectionData = data ?? [];
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final totalPages = (educationSectionData.length / itemsPerPage).ceil();
    bool isMobileView = screenWidth <= 600;
    
    double educationHeight = 
        isMobileView ? screenWidth * 1.0 : screenWidth * 0.4;
    double educationHeight2 = screenWidth * 0.55;
    double titleFontSize =
        isMobileView ? screenWidth * 0.05 : screenWidth * 0.02;


    return SizedBox(
      height: (screenWidth <= 1000 && screenWidth > 600) ? educationHeight2 : educationHeight,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: screenWidth * Constants.kScreenWidthDivider,
              ),
              Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Education History",
                    style: PublicViewTextStyles.generalSubHeading.copyWith(
                      fontSize: titleFontSize,
                    ),
                    textAlign: TextAlign.left,
                    
                  ),
                  SizedBox(
                    width: titleFontSize * 20,
                    child: const Divider(
                      color: Colors.black,
                      thickness: Constants.kScreenDividerThickness,
                    ),
                  ),
                ],
              ),),
            ],
          ),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: totalPages,
              onPageChanged: (int page) {
                setState(() {
                  currentPage = page;
                });
              },
              itemBuilder: (context, page) {
                final startIndex = page * itemsPerPage;
                final endIndex = startIndex + itemsPerPage;
                final pageData = educationSectionData.sublist(
                  startIndex,
                  endIndex < educationSectionData.length
                      ? endIndex
                      : educationSectionData.length,
                );

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pageData.length,
                  itemBuilder: (
                    context,
                    index,
                  ) {
                    return Column(
                      children: [
                        EducationWidget(
                          educationDTO: pageData[index],
                          itemsPerPage: itemsPerPage,
                          numEducation: educationSectionData.length,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: screenWidth * Constants.kScreenWidthDivider,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.black,
                      thickness: Constants.kScreenDividerThickness,
                    ),
                    // hide page indicator
                    totalPages > 1 ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int page = 0; page < totalPages; page++)
                          GestureDetector(
                            onTap: () {
                              _pageController.animateToPage(
                                page,
                                duration: const Duration(
                                    milliseconds:
                                        Constants.pageAnimationDuration),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: Constants.navigationCircleSize,
                              height: Constants.navigationCircleSize,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: Constants.kHorizontalSpacing),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == page
                                    ? Colors.black
                                    : Colors.grey
                                        .withOpacity(Constants.greyOpacity),
                              ),
                            ),
                          ),
                      ],
                    ) : SizedBox(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EducationWidget extends StatelessWidget {
  final EducationDTO educationDTO;
  final int numEducation;
  final int itemsPerPage;
  const EducationWidget(
      {Key? key,
      required this.educationDTO,
      required this.itemsPerPage,
      required this.numEducation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isMobileView = screenWidth <= 600;
    final bool isFirst = (educationDTO.index as int) % itemsPerPage == 0;
    double schoolNameFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.012;
    double dateFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.012;
    double degreeFontSize=
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.012;
    double majorFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.012;
    double gradeFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.012;
    double descriptionFontSize=
        isMobileView ? screenWidth * 0.025 : screenWidth * 0.01;
    double imageRadius = 
        isMobileView ? screenWidth * 0.2: screenWidth * 0.05;
    double gap = 
        isMobileView ? screenWidth * 0.08: screenWidth * 0.055;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * Constants.kScreenWidthDivider,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    painter: DashedLineVerticalPainter(
                      selectedColor: (!isFirst ||
                              ((educationDTO.index as int) ==
                                  (numEducation - 1)))
                          ? Colors.transparent
                          : Colors.black,
                    ),
                    size: const Size(1, double.infinity),
                  ),
                ),
                CircleAvatar(
                  radius: imageRadius,
                  child: Container(
                    alignment: Alignment.center,
                    // width: screenWidth * Constants.kLogoSize,
                    // height: screenWidth * Constants.kLogoSize,
                    // width: imageSize,
                    // height: imageSize,
                    decoration: const BoxDecoration(
                      color: Colors
                          .white, // You can set a background color if needed
                    ),
                    child: Image.network(
                      educationDTO.logoURL as String,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // image and left column gap
          SizedBox(
            width: screenWidth * Constants.kVerticalSpacing,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: isFirst ? Colors.transparent : Colors.black,
                  thickness: Constants.kScreenDividerThickness,
                ),
                SizedBox(
                  height: screenHeight * Constants.kVerticalSpacing,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Expanded(
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          educationDTO.schoolName as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: schoolNameFontSize,
                            ),
                        ),
                        Text(
                          '${educationDTO.startDate as String} - ${educationDTO.endDate as String}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: dateFontSize,
                            ),
                        ),
                      ],
                    ),
                    ),
                    // left and right column gap
                    SizedBox(
                      // width: screenWidth * Constants.kScreenWidthDivider,
                      width: gap,
                    ),
                      Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            educationDTO.degree as String,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic,
                                fontSize: degreeFontSize,
                                ),
                          ),
                          if (educationDTO.major!.isNotEmpty)
                            Text(
                              educationDTO.major!.isNotEmpty
                                  ? educationDTO.major as String
                                  : "",
                              style:
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: majorFontSize,
                                    ),
                            ),
                          if (!educationDTO.grade!.isNegative)
                            Text(
                              (!educationDTO.grade!.isNegative
                                      ? 'Grade: ${educationDTO.grade as double}'
                                      : "") +
                                  (educationDTO.gradeDescription!.isNotEmpty
                                      ? ' - ${educationDTO.gradeDescription as String}'
                                      : ''),
                              style:
                                  TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: gradeFontSize,
                                    ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * Constants.kVerticalSpacing,
                ),
                Expanded(
                  child: Text(
                    educationDTO.description as String,
                    style: TextStyle(
                      fontSize: descriptionFontSize,
                      )
                    // Additional text styling if needed
                  ),
                ),
                SizedBox(
                  // height: screenHeight * Constants.kVerticalSpacing,
                  height: 0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
