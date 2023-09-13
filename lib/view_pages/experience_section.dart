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
            // decoration:
            //     BoxDecoration(border: Border.all(color: Colors.blueAccent)),
            child: Row(
              children: [
                SizedBox(
                  width: 94,
                ),
                Container(
                  width: 78.0, // Width of the image container
                  height: 78.0, // Height of the image container
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
                    // decoration: BoxDecoration(
                    //     border: Border.all(color: Colors.purpleAccent)),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border.all(color: Colors.amberAccent)),
                              width: 10,
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border.all(color: Colors.amberAccent)),
                              width: 450,
                              child: Text(
                                '${experienceDTO.companyName as String}, ${experienceDTO.location as String}',
                                style: PublicViewTextStyles
                                    .professionalExperienceHeading
                                    .copyWith(
                                        color: selectedColor,
                                        fontSize: titleFontSize * 0.97),
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border.all(color: Colors.amberAccent)),
                              width: 40,
                            ),
                            Container(
                                // decoration: BoxDecoration(
                                //     border:
                                //         Border.all(color: Colors.amberAccent)),
                                width: 50,
                                child: ColoredCircle(
                                  selectedColor: selectedColor,
                                )),
                            Container(
                              // decoration: BoxDecoration(
                              //     border:
                              //         Border.all(color: Colors.amberAccent)),
                              width: 98,
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
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.lightGreen)),
                              width: 10,
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.lightGreen)),
                              width: 450,
                              child: Text(
                                '${experienceDTO.startDate as String} - ${experienceDTO.endDate as String}',
                                style: PublicViewTextStyles
                                    .professionalExperienceSubHeading
                                    .copyWith(color: selectedColor),
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //     border: Border.all(color: Colors.lightGreen)),
                              width: 188,
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
            // decoration: BoxDecoration(border: Border.all(color: Colors.red)),
            child: Row(
              children: [
                SizedBox(
                  width: 815,
                ),
                Container(
                    width: 500,
                    child: Text(experienceDTO.description as String,
                        style: PublicViewTextStyles.generalBodyText))
              ],
            ),
          ),
          SizedBox(
            height: 50,
          )
        ]);
      },
    );
  }
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
