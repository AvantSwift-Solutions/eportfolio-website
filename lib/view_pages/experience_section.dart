// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../dto/experience_dto.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

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
                        // SizedBox(
                        //     height:
                        //         16.0), // Adjust the spacing between widgets as needed
                      ],
                    );
                  },
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAllExperiences = !showAllExperiences;
                      });
                    },
                    child: Text(
                      showAllExperiences ? 'Show Less' : 'Show All',
                    ),
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

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final selectedColor = getColorFromNumber((experienceDTO.index as int) - 1);

    final bool isFirst = experienceDTO.index as int == 1;
    // if (experienceDTO.index == 1) {
    //   isFirst = true;
    // }

    double titleFontSize = screenWidth * 0.03;

    return Container(
      child: IntrinsicHeight(
        // decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: screenWidth * 0.05,
            ),
            // Expanded(
            Container(
              // decoration: BoxDecoration(
              //   border: Border.all(color: Colors.pinkAccent),
              // ),

              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: screenWidth * 0.048,
                        height: screenWidth * 0.048,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                NetworkImage(experienceDTO.logoURL as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(25),
                        width: screenWidth * 0.3,
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.purpleAccent),
                        // ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${experienceDTO.companyName as String}, ${experienceDTO.location as String}',
                              style: PublicViewTextStyles
                                  .professionalExperienceHeading
                                  .copyWith(
                                      color: selectedColor,
                                      fontSize: titleFontSize * 0.97),
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
                  Expanded(
                    child: Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(color: Colors.pinkAccent),
                        // ),
                        ),
                  ),
                ],
              ),
            ),

            Container(
              // decoration:
              //     BoxDecoration(border: Border.all(color: Colors.amberAccent)),
              // width: 50,
              width: screenWidth * 0.14,
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: 1,
                            child: CustomPaint(
                              painter: DashedLineVerticalPainter(
                                selectedColor:
                                    isFirst ? Colors.transparent : Colors.black,
                              ),
                              size: Size(1, double.infinity),
                            ),
                          ),
                        ),
                        Expanded(
                          child: CustomPaint(
                            painter: DashedLineVerticalPainter(
                                selectedColor: Colors.black),
                            size: Size(1, double.infinity),
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
                    child: Container(
                      // decoration: BoxDecoration(
                      //     border: Border.all(color: Colors.deepPurple)),
                      // width: 50,
                      width: screenWidth * 0.035,

                      child: ColoredCircle(
                        selectedColor: selectedColor,
                        // selectedColor: const Color(0xFFE6AA68),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Container(
                  //     // decoration: BoxDecoration(
                  //     //     border: Border.all(color: Colors.deepPurple)),
                  //     // width: 10,
                  //     width: screenWidth * 0.007,
                  //     child: ColoredCircle(
                  //       selectedColor: Colors.black,
                  //       // selectedColor: const Color(0xFFE6AA68),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: screenWidth * 0.3,
                // decoration: BoxDecoration(
                //   border: Border.all(color: Colors.purpleAccent),
                // ),
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
                        experienceDTO.location as String,
                        style: PublicViewTextStyles
                            .professionalExperienceSubHeading
                            .copyWith(color: selectedColor),
                      ),
                    ),
                    Text(experienceDTO.description as String,
                        style: PublicViewTextStyles.generalBodyText),
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
      ),
    );
  }
}

class DashedLineVerticalPainter extends CustomPainter {
  final Color selectedColor;

  DashedLineVerticalPainter({required this.selectedColor});

  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 8, dashSpace = 5, startY = 0;
    final paint = Paint()
      ..color = selectedColor
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ColoredCircle extends StatelessWidget {
  final Color selectedColor;

  ColoredCircle({required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.0, // Define the width of the circle
      height: 28.0, // Define the height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // This makes the container a circle
        color: selectedColor, // Specify the color you want
      ),
    );
  }
}

Color getColorFromNumber(int number) {
  const List<Color> colorList = [
    Color.fromRGBO(79, 147, 122, 1),
    Colors.blue,
    Colors.red,
    Colors.orange,
    Colors.yellow,
    // Add more colors as needed
  ];

  // Use modulo to wrap around the colors if the number is too large
  final int index = number % colorList.length;

  return colorList[index];
}


// // ignore_for_file: use_build_context_synchronously

// import 'dart:math';

// import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
// import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
// import 'package:flutter/material.dart';
// import '../dto/experience_dto.dart';
// import '../ui/custom_texts/public_view_text_styles.dart';

// class ExperienceSection extends StatefulWidget {
//   const ExperienceSection({Key? key}) : super(key: key);

//   @override
//   ExperienceSectionState createState() => ExperienceSectionState();
// }

// class ExperienceSectionState extends State<ExperienceSection> {
//   final ExperienceSectionController _experienceSectionController =
//       ExperienceSectionController(ExperienceRepoService());

//   // Variable to track whether to show all experiences or not
//   bool showAllExperiences = false;

//   void dispose() {
//     // Dispose of your controllers or any other resources here
//     // _experienceSectionController.dis

//     super.dispose(); // Call super.dispose() at the end
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _experienceSectionController.getExperienceSectionData(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Error loading data'));
//         }

//         final experienceSectionData = snapshot.data;
//         final screenWidth = MediaQuery.of(context).size.width;

//         double titleFontSize = screenWidth * 0.05;

//         // Determine the number of experiences to display based on showAllExperiences
//         int numExperiences;

//         if (showAllExperiences) {
//           numExperiences = experienceSectionData?.length as int;
//         } else {
//           numExperiences = 3; // You can change this to any desired limit
//         }

//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(50.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Divider(),
//                 RichText(
//                   text: TextSpan(
//                     style: PublicViewTextStyles.generalHeading.copyWith(
//                         fontSize: titleFontSize * 0.8,
//                         fontWeight: FontWeight.bold),
//                     children: const [
//                       TextSpan(
//                         text: 'Professional\n',
//                       ),
//                       TextSpan(
//                         text: 'Experience',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 60.0),

//                 // Use ListView.builder to dynamically create ExperienceWidgets
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: numExperiences,
//                   itemBuilder: (context, index) {
//                     return Column(
//                       children: [
//                         ExperienceWidget(experienceIndex: index),
//                         // SizedBox(
//                         //     height:
//                         //         16.0), // Adjust the spacing between widgets as needed
//                       ],
//                     );
//                   },
//                 ),
//                 Center(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         showAllExperiences = !showAllExperiences;
//                       });
//                     },
//                     child: Text(
//                       showAllExperiences ? 'Show Less' : 'Show All',
//                     ),
//                   ),
//                 )

//                 // Button to toggle showing all experiences or a limited number
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class ExperienceWidget extends StatefulWidget {
//   final int experienceIndex;
//   const ExperienceWidget({super.key, required this.experienceIndex});

//   @override
//   ExperienceWidgetState createState() => ExperienceWidgetState();
// }

// class ExperienceWidgetState extends State<ExperienceWidget> {
//   final ExperienceSectionController _experienceSectionController =
//       ExperienceSectionController(ExperienceRepoService());

//   final _jobTitleController = TextEditingController();
//   final _companyNameController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _startDateController = TextEditingController();
//   final _endDateController = TextEditingController();
//   final _jobDescriptionController = TextEditingController();
//   final _logoURLController = TextEditingController();

//   @override
//   void dispose() {
//     _jobTitleController.dispose();
//     _companyNameController.dispose();
//     _locationController.dispose();
//     _startDateController.dispose();
//     _endDateController.dispose();
//     _jobDescriptionController.dispose();
//     _logoURLController.dispose();
//     super.dispose();
//   }

//   void clear() {
//     _jobTitleController.clear();
//     _companyNameController.clear();
//     _locationController.clear();
//     _startDateController.clear();
//     _endDateController.clear();
//     _jobDescriptionController.clear();
//     _logoURLController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: _experienceSectionController
//           .getExperienceData(widget.experienceIndex),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return const Center(child: Text('Error loading data'));
//         }

//         final experienceDTO = snapshot.data as ExperienceDTO;

//         final screenWidth = MediaQuery.of(context).size.width;

//         final selectedColor = getColorFromNumber(widget.experienceIndex);

//         double titleFontSize = screenWidth * 0.03;

//         return Column(children: [
//           Container(
//             // decoration:
//             //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: screenWidth * 0.05,
//                   // width: 94,
//                 ),
//                 Container(
//                   width: screenWidth * 0.048,
//                   height: screenWidth * 0.048,
//                   // width: 78.0, // Width of the image container
//                   // height: 78.0, // Height of the image container
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(experienceDTO.logoURL as String),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     // padding: const EdgeInsets.all(10),
//                     // decoration: BoxDecoration(
//                     //     border: Border.all(color: Colors.purpleAccent)),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border:
//                               //         Border.all(color: Colors.amberAccent)),
//                               // width: 10,
//                               width: screenWidth * 0.007,
//                             ),
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border:
//                               //         Border.all(color: Colors.amberAccent)),
//                               width: screenWidth * 0.293,
//                               // width: 450,
//                               child: Text(
//                                 '${experienceDTO.companyName as String}, ${experienceDTO.location as String}',
//                                 style: PublicViewTextStyles
//                                     .professionalExperienceHeading
//                                     .copyWith(
//                                         color: selectedColor,
//                                         fontSize: titleFontSize * 0.97),
//                               ),
//                             ),
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border:
//                               //         Border.all(color: Colors.amberAccent)),
//                               // width: 40,
//                               width: screenWidth * 0.028,
//                             ),
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border:
//                               //         Border.all(color: Colors.amberAccent)),
//                               // width: 50,
//                               width: screenWidth * 0.035,
//                               child: Stack(
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       // width: 50,
//                                       width: screenWidth * 0.035,

//                                       child: ColoredCircle(
//                                         selectedColor: selectedColor,
//                                         // selectedColor: const Color(0xFFE6AA68),
//                                       ),
//                                     ),
//                                   ),
//                                   Center(
//                                     child: Container(
//                                       // width: 10,
//                                       width: screenWidth * 0.007,
//                                       child: ColoredCircle(
//                                         selectedColor: Colors.black,
//                                         // selectedColor: const Color(0xFFE6AA68),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                                 // decoration: BoxDecoration(
//                                 //     border:
//                                 //         Border.all(color: Colors.amberAccent)),
//                                 // width: 98,
//                                 width: screenWidth * 0.058),
//                             Expanded(
//                               child: Text(
//                                 experienceDTO.jobTitle as String,
//                                 style: PublicViewTextStyles
//                                     .professionalExperienceHeading
//                                     .copyWith(color: selectedColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border: Border.all(color: Colors.lightGreen)),
//                               width: screenWidth * 0.007,
//                             ),
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border: Border.all(color: Colors.lightGreen)),
//                               width: screenWidth * 0.293,
//                               child: Text(
//                                 '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
//                                 style: PublicViewTextStyles
//                                     .professionalExperienceSubHeading
//                                     .copyWith(color: selectedColor),
//                               ),
//                             ),
//                             Container(
//                               // decoration: BoxDecoration(
//                               //     border: Border.all(color: Colors.lightGreen)),
//                               width: (screenWidth * 0.028) +
//                                   (screenWidth * 0.035) +
//                                   (screenWidth * 0.058),

//                               // width: 188,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
//                                 style: PublicViewTextStyles
//                                     .professionalExperienceSubHeading
//                                     .copyWith(color: selectedColor),
//                               ),
//                             )
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.all(5),
//             // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
//             child: Row(
//               children: [
//                 SizedBox(
//                   width: 815,
//                 ),
//                 Container(
//                     width: 500,
//                     child: Text(experienceDTO.description as String,
//                         style: PublicViewTextStyles.generalBodyText))
//               ],
//             ),
//           ),
//           SizedBox(
//             height: 50,
//           )
//         ]);
//       },
//     );
//   }
// }

// class ColoredCircle extends StatelessWidget {
//   final Color selectedColor;

//   ColoredCircle({required this.selectedColor});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 28.0, // Define the width of the circle
//       height: 28.0, // Define the height of the circle
//       decoration: BoxDecoration(
//         shape: BoxShape.circle, // This makes the container a circle
//         color: selectedColor, // Specify the color you want
//       ),
//     );
//   }
// }

// Color getColorFromNumber(int number) {
//   const List<Color> colorList = [
//     Colors.green,
//     Colors.blue,
//     Colors.red,
//     Colors.orange,
//     Colors.yellow,
//     // Add more colors as needed
//   ];

//   // Use modulo to wrap around the colors if the number is too large
//   final int index = number % colorList.length;

//   return colorList[index];
// }

// class DottedCircle extends StatelessWidget {
//   final double radius;
//   final Color circleColor;
//   final Color borderColor;
//   final double borderWidth;
//   final double dotRadius;

//   DottedCircle({
//     required this.radius,
//     required this.circleColor,
//     required this.borderColor,
//     required this.borderWidth,
//     required this.dotRadius,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       size: Size(radius * 2, radius * 2),
//       painter: DottedCirclePainter(
//         radius: radius,
//         circleColor: circleColor,
//         borderColor: borderColor,
//         borderWidth: borderWidth,
//         dotRadius: dotRadius,
//       ),
//     );
//   }
// }

// class DottedCirclePainter extends CustomPainter {
//   final double radius;
//   final Color circleColor;
//   final Color borderColor;
//   final double borderWidth;
//   final double dotRadius;

//   DottedCirclePainter({
//     required this.radius,
//     required this.circleColor,
//     required this.borderColor,
//     required this.borderWidth,
//     required this.dotRadius,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint circlePaint = Paint()
//       ..color = circleColor
//       ..style = PaintingStyle.fill;

//     final Paint borderPaint = Paint()
//       ..color = borderColor
//       ..strokeWidth = borderWidth
//       ..style = PaintingStyle.stroke;

//     final double centerX = size.width / 2;
//     final double centerY = size.height / 2;

//     // Draw the circle
//     canvas.drawCircle(Offset(centerX, centerY), radius, circlePaint);

//     // Draw the dotted border
//     final double circumference = 2 * pi * radius;
//     final int numberOfDots = (circumference / (dotRadius * 2)).floor();

//     final double deltaAngle = (2 * pi) / numberOfDots;

//     for (int i = 0; i < numberOfDots; i++) {
//       final double angle = i * deltaAngle;

//       final double x = centerX + (radius + borderWidth / 2) * cos(angle);
//       final double y = centerY + (radius + borderWidth / 2) * sin(angle);

//       canvas.drawCircle(Offset(x, y), dotRadius, borderPaint);
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return false;
//   }
// }

