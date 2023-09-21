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
  const ExperienceSection({Key? key}) : super(key: key);

  @override
  ExperienceSectionState createState() => ExperienceSectionState();
}

class ExperienceSectionState extends State<ExperienceSection> {
  final ExperienceSectionController _experienceSectionController =
      ExperienceSectionController(ExperienceRepoService());

  // Variable to track whether to show all experiences or not
  bool showAllExperiences = false;

  @override
  void dispose() {
    super.dispose(); // Call super.dispose() at the end
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _experienceSectionController.getExperienceSectionData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final experienceSectionData = snapshot.data;
        final screenWidth = MediaQuery.of(context).size.width;

        double titleFontSize = screenWidth * 0.05;

        // Determine the number of experiences to display based on showAllExperiences
        int numExperiences;

        if (showAllExperiences) {
          numExperiences = experienceSectionData?.length as int;
        } else {
          numExperiences = 3; // You can change this to any desired limit
        }

        return Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(),
                RichText(
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
                ),

                const SizedBox(height: 60.0),

                // Use ListView.builder to dynamically create ExperienceWidgets
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: numExperiences,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ExperienceWidget(
                            experienceDTO:
                                experienceSectionData!.elementAt(index)),
                      ],
                    );
                  },
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
                )
                // Button to toggle showing all experiences or a limited number
              ],
            ),
          ),
        );
      },
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

    double titleFontSize = screenWidth * 0.03;

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
                  Container(
                    width: screenWidth * 0.048,
                    height: screenWidth * 0.048,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(experienceDTO.logoURL as String),
                        fit: BoxFit.cover,
                      ),
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
                              (experienceDTO.location!.isNotEmpty
                                  ? ', ${experienceDTO.location as String}'
                                  : ''),
                          style: PublicViewTextStyles
                              .professionalExperienceHeading
                              .copyWith(
                            color: selectedColor,
                            fontSize: titleFontSize * 0.97,
                          ),
                        ),
                        Text(
                          '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                          style: PublicViewTextStyles
                              .professionalExperienceSubHeading
                              .copyWith(color: selectedColor),
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
                      height: 50,
                      width: 50,
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
                            color: selectedColor,
                            fontSize: titleFontSize * 0.97),
                  ),
                  Expanded(
                    child: Text(
                      experienceDTO.employmentType as String,
                      style: PublicViewTextStyles
                          .professionalExperienceSubHeading
                          .copyWith(color: selectedColor),
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.003,
                  ),
                  Text(experienceDTO.description as String,
                      style: PublicViewTextStyles.generalBodyText),
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
