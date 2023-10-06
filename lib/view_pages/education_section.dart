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
  bool showAllEducation = false;
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
    final totalPages = (educationSectionData.length / itemsPerPage).ceil();

    final int screenWidth = MediaQuery.of(context).size.width as int;

    return SizedBox(
      height: Constants
          .educationWidgetHeight, // Specify a fixed height here or calculate it based on your layout,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: screenWidth * Constants.kScreenWidthDivider,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Education History",
                    style: PublicViewTextStyles.generalSubHeading,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: screenWidth * Constants.kTitleDividerLength,
                    child: const Divider(
                      color: Colors.black,
                      thickness: Constants.kScreenDividerThickness,
                    ),
                  ),
                ],
              ),
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
                width: MediaQuery.of(context).size.width *
                    Constants.kScreenWidthDivider,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.black,
                      thickness: Constants.kScreenDividerThickness,
                    ),
                    Row(
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
                    ),
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

    final bool isFirst = (educationDTO.index as int) % itemsPerPage == 0;

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
                ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * Constants.kLogoSize,
                    height: screenWidth * Constants.kLogoSize,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          educationDTO.schoolName as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${educationDTO.startDate as String} - ${educationDTO.endDate as String}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth * Constants.kScreenWidthDivider,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            educationDTO.degree as String,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                          if (educationDTO.major!.isNotEmpty)
                            Text(
                              educationDTO.major!.isNotEmpty
                                  ? educationDTO.major as String
                                  : "",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          if (!educationDTO.grade!.isNegative)
                            Text(
                              (!educationDTO.grade!.isNegative
                                      ? 'Grade: ${educationDTO.grade as int}'
                                      : "") +
                                  (educationDTO.gradeDescription!.isNotEmpty
                                      ? ' - ${educationDTO.gradeDescription as String}'
                                      : ''),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                    // Additional text styling if needed
                  ),
                ),
                SizedBox(
                  height: screenHeight * Constants.kVerticalSpacing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
