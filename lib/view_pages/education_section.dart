// ignore_for_file: use_build_context_synchronously

import 'dart:js_interop';

import 'package:flutter/material.dart';
import '../controllers/view_controllers/education_section_controller.dart';
import '../dto/education_section_dto.dart';
import '../reposervice/education_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import '../ui/dashed_vertical_line_painter.dart';

class EducationSection extends StatefulWidget {
  const EducationSection({Key? key}) : super(key: key);

  @override
  EducationSectionState createState() => EducationSectionState();
}

class EducationSectionState extends State<EducationSection> {
  final EducationSectionController _educationSectionController =
      EducationSectionController(EducationRepoService());

  // Variable to track whether to show all experiences or not
  bool showAllEducation = false;

  @override
  void dispose() {
    super.dispose(); // Call super.dispose() at the end
  }

  int currentPage = 0;
  static const itemsPerPage = 2;

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

// Calculate the total number of pages
        final totalPages = (educationSectionData!.length / itemsPerPage).ceil();

        double titleFontSize = screenWidth * 0.05;

        // Determine the number of experiences to display based on showAllExperiences
        int numEducation;

        if (showAllEducation) {
          numEducation = educationSectionData?.length as int;
        } else {
          numEducation = 2; // You can change this to any desired limit
        }

        return Container(
          width: screenWidth * 0.4 + screenWidth * 0.006,
          // decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.055,
                  ),
                  Text(
                    "Education History",
                    style: PublicViewTextStyles.generalSubHeading,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemsPerPage,
                itemBuilder: (context, index) {
                  final dataIndex = currentPage * itemsPerPage + index;
                  if (dataIndex < educationSectionData.length) {
                    return Column(
                      children: [
                        EducationWidget(
                          educationDTO: educationSectionData[dataIndex],
                        ),
                      ],
                    );
                  } else {
                    return SizedBox(); // Return an empty widget if there are no more items.
                  }
                },
              ),
              Row(
                children: [
                  SizedBox(
                    width: screenWidth * 0.055,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int page = 0; page < totalPages; page++)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentPage = page;
                                });
                              },
                              child: Container(
                                width: 10,
                                height: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: currentPage == page
                                      ? Colors.black
                                      : Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
// test

class EducationWidget extends StatelessWidget {
  final EducationDTO educationDTO;
  const EducationWidget({super.key, required this.educationDTO});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final bool isFirst = educationDTO.index as int == 0;

    double titleFontSize = screenWidth * 0.03;

    return IntrinsicHeight(
      // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenWidth * 0.05,
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    painter: DashedLineVerticalPainter(
                      selectedColor:
                          !isFirst ? Colors.transparent : Colors.black,
                    ),
                    size: const Size(1, double.infinity),
                  ),
                ),
                ClipOval(
                  child: Container(
                    alignment: Alignment.center,
                    width: screenWidth * 0.048,
                    height: screenWidth * 0.048,
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
            width: screenWidth * 0.006,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.black,
                  thickness: 2,
                ),
                SizedBox(
                  width: screenWidth * 0.006,
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
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${educationDTO.startDate as String} - ${educationDTO.endDate as String}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: screenWidth * 0.05,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            educationDTO.degree as String,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          if (!educationDTO.major.isNull)
                            Text(
                              !educationDTO.major.isNull
                                  ? '${educationDTO.major as String}'
                                  : "",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          if (!educationDTO.grade!.isNegative)
                            Text(
                              (!educationDTO.grade!.isNegative
                                      ? 'Grade: ${educationDTO.grade as int}'
                                      : "") +
                                  (educationDTO.gradeDescription!.isNotEmpty
                                      ? ' - ${educationDTO.gradeDescription as String}'
                                      : ''),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.015,
                ),
                Expanded(
                  child: Text(educationDTO.description as String),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
