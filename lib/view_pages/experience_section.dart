// ignore_for_file: use_build_context_synchronously

import 'package:avantswift_portfolio/controllers/view_controllers/experience_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/experience_repo_services.dart';
import 'package:flutter/material.dart';
import '../controllers/view_controllers/contact_section_controller.dart';
import '../dto/experience_dto.dart';
import '../reposervice/user_repo_services.dart';
import '../ui/custom_view_button.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    // Dispose of your controllers or any other resources here
    // _experienceSectionController.dis

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
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: numExperiences,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ExperienceWidget(experienceIndex: index),
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

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black // Adjust the color of the dashed line
      ..strokeWidth = 1 // Adjust the width of the dashed line
      ..style = PaintingStyle.stroke;

    final dashWidth = 5; // Adjust the width of each dash
    final dashSpace = 5; // Adjust the space between dashes

    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + dashWidth), paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class ExperienceWidget extends StatefulWidget {
  final int experienceIndex;
  const ExperienceWidget({required this.experienceIndex});

  ExperienceWidgetState createState() => ExperienceWidgetState();
}

class ExperienceWidgetState extends State<ExperienceWidget> {
  final ExperienceSectionController _experienceSectionController =
      ExperienceSectionController(ExperienceRepoService());

  final _jobTitleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _locationController = TextEditingController();
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _logoURLController = TextEditingController();

  void dispose() {
    _jobTitleController.dispose();
    _companyNameController.dispose();
    _locationController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _jobDescriptionController.dispose();
    _logoURLController.dispose();
  }

  void clear() {
    _jobTitleController.clear();
    _companyNameController.clear();
    _locationController.clear();
    _startDateController.clear();
    _endDateController.clear();
    _jobDescriptionController.clear();
    _logoURLController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _experienceSectionController
          .getExperienceData(widget.experienceIndex),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }

        final experienceDTO = snapshot.data as ExperienceDTO;

        final screenWidth = MediaQuery.of(context).size.width;

        final selectedColor = getColorFromNumber(widget.experienceIndex);

        double titleFontSize = screenWidth * 0.03;

        return Column(children: [
          Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                ),
                Container(
                  width: 75.0, // Width of the image container
                  height: 75.0, // Height of the image container
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(experienceDTO.logoURL as String),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.purpleAccent)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amberAccent)),
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amberAccent)),
                              width: 400,
                              child: Text(
                                '${experienceDTO.companyName as String}, ${experienceDTO.location as String}',
                                style: PublicViewTextStyles
                                    .professionalExperienceHeading
                                    .copyWith(color: selectedColor),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amberAccent)),
                              width: 40,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.amberAccent)),
                                width: 50,
                                child: ColoredCircle(
                                  selectedColor: selectedColor,
                                )),
                            Container(
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.amberAccent)),
                              width: 85,
                            ),
                            Expanded(
                              child: Text(
                                experienceDTO.jobTitle as String,
                                style: PublicViewTextStyles
                                    .professionalExperienceHeading
                                    .copyWith(color: selectedColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightGreen)),
                              width: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightGreen)),
                              width: 440,
                              child: Text(
                                '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                                style: PublicViewTextStyles
                                    .professionalExperienceSubHeading
                                    .copyWith(color: selectedColor),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.lightGreen)),
                              width: 135,
                            ),
                            Expanded(
                              child: Text(
                                '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                                style: PublicViewTextStyles
                                    .professionalExperienceSubHeading
                                    .copyWith(color: selectedColor),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Row(
              children: [
                SizedBox(
                  width: 735,
                ),
                Expanded(
                    child: Text(experienceDTO.description as String,
                        style: PublicViewTextStyles.generalBodyText))
              ],
            ),
          ),
        ]);

        // return Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: <Widget>[
        //     Container(
        //       color: Colors.transparent,
        //       width: 80,
        //     ),
        //     Expanded(
        //       child: ExperienceWidgetLeft(
        //         endDate: experienceDTO.endDate as String,
        //         startDate: experienceDTO.startDate as String,
        //         companyName: experienceDTO.companyName as String,
        //         location: experienceDTO.location as String,
        //         imageUrl: experienceDTO.logoURL as String,
        //         selectedColor: selectedColor,
        //       ),
        //     ),
        //     Container(
        //       width: 80,
        //       height: 60,
        // decoration:
        //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
        //       child: Center(
        //         child: ColoredCircle(
        //           selectedColor: selectedColor,
        //         ),
        //       ),
        //     ),

        //     // Expanded(

        //     // ),
        //     Expanded(
        //       child: ExperienceWidgetRight(
        //         jobTitle: experienceDTO.jobTitle as String,
        //         description: experienceDTO.description as String,
        //         selectedColor: selectedColor,
        //       ),
        //     ),
        //     Container(
        //       color: Colors.transparent,
        //       width: 80,
        //     ),
        //   ],
        // );
      },
    );
  }
}

class ExperienceWidgetLeft extends StatelessWidget {
  final String companyName;
  final String location;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final Color selectedColor;

  ExperienceWidgetLeft({
    required this.companyName,
    required this.location,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    // return Expanded(
    return Column(
      // child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 70.0, // Width of the image container
              height: 70.0, // Height of the image container
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 16.0), // Space between image and event details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$companyName, $location',
                    style: PublicViewTextStyles.professionalExperienceHeading
                        .copyWith(color: selectedColor),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    '$startDate - $endDate',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: selectedColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
      // ),
    );
  }
}

class ExperienceWidgetRight extends StatelessWidget {
  final String jobTitle;
  final String description;
  final Color selectedColor;

  ExperienceWidgetRight({
    required this.jobTitle,
    required this.description,
    required this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          jobTitle,
          // style: TextStyle(
          //   fontSize: 18.0,
          //   fontWeight: FontWeight.bold,
          //   color: selectedColor,
          // ),
          style: PublicViewTextStyles.professionalExperienceHeading
              .copyWith(color: selectedColor),
        ),
        SizedBox(height: 8.0),
        Text(
          description,
          style: PublicViewTextStyles.educationDescription,
        ),
      ],
    );
  }
}

class ColoredCircle extends StatelessWidget {
  final Color selectedColor;

  ColoredCircle({required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26.0, // Define the width of the circle
      height: 26.0, // Define the height of the circle
      decoration: BoxDecoration(
        shape: BoxShape.circle, // This makes the container a circle
        color: selectedColor, // Specify the color you want
      ),
    );
  }
}

Color getColorFromNumber(int number) {
  const List<Color> colorList = [
    Colors.green,
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
