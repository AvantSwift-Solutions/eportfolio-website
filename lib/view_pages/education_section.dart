import 'package:flutter/material.dart';
import '../controllers/view_controllers/education_section_controller.dart';
import '../dto/education_section_dto.dart';
import '../reposervice/education_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/dashed_vertical_line_painter.dart';

// Define constants
const double kScreenWidthDivider = 0.055;
const double kScreenDividerThickness = 2.0;
const double kLogoSize = 0.048;
const double kVerticalSpacing = 0.015;
const double kHorizontalSpacing = 5;
const double educationWidgetHeight = 400;
const double navigationCircleSize = 10;
const double greyOpacity = 0.5;
const int pageAnimationDuration = 300;
const double kTitleDividerLength = 0.319;

class EducationSection extends StatefulWidget {
  const EducationSection({Key? key}) : super(key: key);

  @override
  EducationSectionState createState() => EducationSectionState();
}

class EducationSectionState extends State<EducationSection> {
  final EducationSectionController _educationSectionController =
      EducationSectionController(EducationRepoService());

  List<EducationDTO> educationSectionData = [];
  bool showAllEducation = false;
  int currentPage = 0;
  static const itemsPerPage = 2;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
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
    return FutureBuilder(
      future: _educationSectionController.getEducationSectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final educationSectionData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        // Determine the number of experiences to display based on showAllExperiences
        int numEducation;

        if (showAllEducation) {
          numEducation = educationSectionData?.length as int;
        } else {
          numEducation = 2; // You can change this to any desired limit
        }

        return SizedBox(
          width: screenWidth * 0.4 + screenWidth * 0.006,
          // decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                  Text(
                    'Education History',
                    style: PublicViewTextStyles.generalSubHeading,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: screenWidth * kTitleDividerLength,
                    child: const Divider(
                      color: Colors.black,
                      thickness: kScreenDividerThickness,
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
                width: MediaQuery.of(context).size.width * kScreenWidthDivider,
              ),
              Expanded(
                child: Column(
                  children: [
                    const Divider(
                      color: Colors.black,
                      thickness: kScreenDividerThickness,
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
                                    milliseconds: pageAnimationDuration),
                                curve: Curves.easeInOut,
                              );
                            },
                            child: Container(
                              width: navigationCircleSize,
                              height: navigationCircleSize,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: kHorizontalSpacing),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentPage == page
                                    ? Colors.black
                                    : Colors.grey.withOpacity(greyOpacity),
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

    final bool isFirst = educationDTO.index as int == 0;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * kScreenWidthDivider,
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
                    width: screenWidth * kLogoSize,
                    height: screenWidth * kLogoSize,
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
            width: screenWidth * kVerticalSpacing,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  color: isFirst ? Colors.transparent : Colors.black,
                  thickness: kScreenDividerThickness,
                ),
                SizedBox(
                  height: screenHeight * kVerticalSpacing,
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
                      width: screenWidth * kScreenWidthDivider,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(educationDTO.degree as String),
                          Text(!educationDTO.major.isNull
                              ? educationDTO.major as String
                              : ''),
                          Text((!educationDTO.grade!.isNegative
                                  ? 'Grade: ${educationDTO.grade as int}'
                                  : '') +
                              (educationDTO.gradeDescription!.isNotEmpty
                                  ? ' - ${educationDTO.gradeDescription as String}'
                                  : '')),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * kVerticalSpacing,
                ),
                Expanded(
                  child: Text(
                    educationDTO.description as String,
                    // Additional text styling if needed
                  ),
                ),
                SizedBox(
                  height: screenHeight * kVerticalSpacing,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
