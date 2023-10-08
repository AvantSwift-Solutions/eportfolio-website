// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
import 'package:avantswift_portfolio/ui/custom_view_more_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../dto/experience_dto.dart';
import '../ui/color_cycle.dart';
import '../ui/colored_circle.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/dashed_vertical_line_painter.dart';

class ExperienceSection extends StatefulWidget {
  final ExperienceSectionController? controller;
  const ExperienceSection({Key? key, this.controller}) : super(key: key);

  @override
  ExperienceSectionState createState() => ExperienceSectionState();
}

class ExperienceSectionState extends State<ExperienceSection> {
  late ExperienceSectionController _experienceSectionController;

  // Variable to track whether to show all experiences or not
  bool showAllExperiences = false;
  List<ExperienceDTO>? experienceSectionData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _experienceSectionController = widget.controller ??
        ExperienceSectionController(ExperienceRepoService());
    _loadExperienceData();
  }

  Future<void> _loadExperienceData() async {
    try {
      final data =
          await _experienceSectionController.getExperienceSectionData();
      setState(() {
        experienceSectionData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // Handle error loading data
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 768;

    double titleFontSize = screenWidth * 0.05;

    // Determine the number of experiences to display based on showAllExperiences
    int numExperiences;

    if (showAllExperiences) {
      numExperiences = experienceSectionData?.length ?? 0;
    } else {
      numExperiences = 3; // You can change this to any desired limit
    }

    return Center(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.035),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (!isMobileView) ? const Divider() : Container(),
            (!isMobileView)
                ? RichText(
                    text: TextSpan(
                      style: PublicViewTextStyles.generalHeading.copyWith(
                          fontSize: titleFontSize * 0.8,
                          fontWeight: FontWeight.bold),
                      children: const [
                        TextSpan(
                          text: 'Professional\n',
                        ),
                        TextSpan(
                          text: 'Experience',
                        ),
                      ],
                    ),
                  )
                :
                // Center(
                RichText(
                    text: TextSpan(
                      style: PublicViewTextStyles.generalHeading.copyWith(
                          fontSize: titleFontSize * 1.4,
                          fontWeight: FontWeight.bold),
                      children: const [
                        TextSpan(
                          text: 'Professional\n',
                        ),
                        TextSpan(
                          text: 'Experience',
                        ),
                      ],
                    ),
                  ),
            // ),

            SizedBox(height: screenWidth * 0.042),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      for (int index = 0; index < numExperiences; index++)
                        (!isMobileView)
                            ? ExperienceWidget(
                                experienceDTO: experienceSectionData![index],
                              )
                            : ExperienceMobileWidget(
                                experienceDTO: experienceSectionData![index]),
                    ],
                  ),

            Center(
              child: CustomViewMoreButton(
                initialValue: showAllExperiences,
                onPressed: () {
                  setState(() {
                    showAllExperiences = !showAllExperiences;
                  });
                },
              ),
            ),
            // Button to toggle showing all experiences or a limited number
          ],
        ),
      ),
    );
  }
}

class ExperienceWidget extends StatelessWidget {
  final ExperienceDTO experienceDTO;
  const ExperienceWidget({super.key, required this.experienceDTO});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final selectedColor = getColorFromNumber((experienceDTO.index as int));

    final bool isFirst = experienceDTO.index as int == 0;

    double titleFontSize = screenWidth * 0.03 * 0.97;
    double subHeadingFontSize = screenWidth * 0.03 * 0.7;
    double descriptionFontSize = screenWidth * 0.01;

    return IntrinsicHeight(
      child: Row(
        children: [
          SizedBox(
            width: screenWidth * 0.05,
          ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.048,
                    height: screenWidth * 0.048,
                    child: Image.network(
                      experienceDTO.logoURL as String,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(25),
                    width: screenWidth * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (experienceDTO.companyName as String) +
                              ((experienceDTO.location ?? 'Default Location')
                                      .isNotEmpty
                                  ? ', ${experienceDTO.location as String}'
                                  : ''),
                          style: PublicViewTextStyles
                              .professionalExperienceHeading
                              .copyWith(
                            color: selectedColor,
                            fontSize: titleFontSize,
                          ),
                        ),
                        Text(
                          '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                          style: PublicViewTextStyles
                              .professionalExperienceSubHeading
                              .copyWith(
                                  color: selectedColor,
                                  fontSize: subHeadingFontSize),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            width: screenWidth * 0.14,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 1,
                          child: CustomPaint(
                            painter: DashedLineVerticalPainter(
                              selectedColor:
                                  isFirst ? Colors.transparent : Colors.black,
                            ),
                            size: const Size(1, double.infinity),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomPaint(
                          painter: DashedLineVerticalPainter(
                              selectedColor: Colors.black),
                          size: const Size(1, double.infinity),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: DottedBorder(
                    borderType: BorderType.Circle,
                    dashPattern: const [5, 10],
                    child: Container(
                      height: screenWidth * 0.04,
                      width: screenWidth * 0.04,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: SizedBox(
                    width: screenWidth * 0.035,
                    child: ColoredCircle(
                      selectedColor: selectedColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              width: screenWidth * 0.3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experienceDTO.jobTitle as String,
                    style: PublicViewTextStyles.professionalExperienceHeading
                        .copyWith(
                            color: selectedColor, fontSize: titleFontSize),
                  ),
                  Expanded(
                    child: Text(
                      experienceDTO.employmentType as String,
                      style: PublicViewTextStyles
                          .professionalExperienceSubHeading
                          .copyWith(
                              color: selectedColor,
                              fontSize: subHeadingFontSize),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  Text(experienceDTO.description as String,
                      style: PublicViewTextStyles.generalBodyText
                          .copyWith(fontSize: descriptionFontSize)),
                  // Text(experienceDTO.index.toString(),
                  //     style: PublicViewTextStyles.generalBodyText),
                  Container(
                    height: screenHeight * 0.05,
                  )
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth * 0.1,
          ),
        ],
      ),
    );
  }
}

class ExperienceMobileWidget extends StatelessWidget {
  final ExperienceDTO experienceDTO;
  const ExperienceMobileWidget({super.key, required this.experienceDTO});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final selectedColor = getColorFromNumber((experienceDTO.index as int));

    double titleFontSize = screenWidth * 0.03 * 1.6;
    double subHeadingFontSize = titleFontSize * 0.7;
    double descriptionFontSize = screenWidth * 0.01;

    return IntrinsicHeight(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // SizedBox(
          //   width: screenWidth * 0.05,
          // ),
          Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.1,
                    height: screenWidth * 0.1,
                    child: Image.network(
                      experienceDTO.logoURL as String,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    // decoration:
                    //     BoxDecoration(border: Border.all(color: Colors.black)),
                    padding: const EdgeInsets.all(10),
                    width: screenWidth * 0.35,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (experienceDTO.companyName as String) +
                              ((experienceDTO.location ?? 'Default Location')
                                      .isNotEmpty
                                  ? ', ${experienceDTO.location as String}'
                                  : ''),
                          style: PublicViewTextStyles
                              .professionalExperienceHeading
                              .copyWith(
                            color: selectedColor,
                            fontSize: titleFontSize,
                          ),
                        ),
                        Text(
                          '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                          style: PublicViewTextStyles
                              .professionalExperienceSubHeading
                              .copyWith(
                            color: selectedColor,
                            fontSize: subHeadingFontSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: screenWidth * 0.14,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  // Center(
                  Column(
                    children: [
                      // Expanded(
                      //   child: SizedBox(
                      //     width: 1,
                      //     child: CustomPaint(
                      //       painter: DashedLineVerticalPainter(
                      //         selectedColor: Colors.black,
                      //       ),
                      //       size: const Size(1, double.infinity),
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        child: CustomPaint(
                          painter: DashedLineVerticalPainter(
                              selectedColor: Colors.black),
                          size: const Size(1, double.infinity),
                        ),
                      ),
                    ],
                    // ),
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        DottedBorder(
                          borderType: BorderType.Circle,
                          dashPattern: const [5, 10],
                          child: Container(
                            height: screenWidth * 0.1,
                            width: screenWidth * 0.1,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle, color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: screenWidth * 0.1,
                          child: ColoredCircle(
                            selectedColor: selectedColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.black),
              // ),
              padding: const EdgeInsets.all(5),
              // width: screenWidth * 0.,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    experienceDTO.jobTitle as String,
                    style: PublicViewTextStyles.professionalExperienceHeading
                        .copyWith(
                            color: selectedColor, fontSize: titleFontSize),
                  ),
                  Expanded(
                    child: Text(
                      experienceDTO.employmentType as String,
                      style: PublicViewTextStyles
                          .professionalExperienceSubHeading
                          .copyWith(
                              color: selectedColor,
                              fontSize: subHeadingFontSize),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  Text(experienceDTO.description as String,
                      style: PublicViewTextStyles.generalBodyText
                          .copyWith(fontSize: descriptionFontSize * 2.5)),
                  // Text(experienceDTO.index.toString(),
                  //     style: PublicViewTextStyles.generalBodyText),
                  Container(
                    height: screenHeight * 0.05,
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   width: screenWidth * 0.1,
          // ),
        ],
      ),
    );
  }
}
