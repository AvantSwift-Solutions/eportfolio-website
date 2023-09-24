import 'dart:developer';

import 'package:avantswift_portfolio/constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../controllers/view_controllers/project_section_controller.dart';
import '../models/Project.dart';
import '../reposervice/project_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({Key? key}) : super(key: key);

  @override
  ProjectSectionState createState() => ProjectSectionState();
}

class ProjectSectionState extends State<ProjectSection> {
  final ProjectSectionController _projectController =
      ProjectSectionController(ProjectRepoService());
  List<Project>? allProjects;
  String sectionDescription = Constants.defaultProjectSectionDescription;
  bool showAllProjects = false;
  int initiallyDisplayedProjects = 3;
  int colorIndex = 0;
  bool _isHovered = false;
  final List<Color> alternatingColors = [
    Colors.orange.shade200,
    Colors.blue.shade200,
    Colors.green.shade200
  ];
  Color projectCardColor =
      Colors.orange.shade200; // Initialize with the first color

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      sectionDescription = await _projectController.getSectionDescription();
      sectionDescription = '"$sectionDescription"';
      final List<Project>? fetchedProjects =
          await _projectController.getProjectList();
      setState(() {
        allProjects = fetchedProjects;
      });
    } catch (e) {
      log('Error fetching projects: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  Color getNextColor() {
    Color nextColor = projectCardColor;
    colorIndex = (colorIndex + 1) % alternatingColors.length;
    projectCardColor = alternatingColors[
        colorIndex]; // Update the project card color for the next iteration
    return nextColor;
  }

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      log('Could not launch $link');
    }
  }

  void openSvgLink() {
    const svgUrl =
        'assets/external_link.svg'; // Replace with your desired URL for the SVG
    openLink(svgUrl);
  }

  void openCustomLink() async {
    const url = 'https://example.com'; // Replace with your desired URL (github)
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      log('Could not launch $url');
    }
  }

  void toggleShowAllProjects() {
    setState(() {
      if (showAllProjects) {
        initiallyDisplayedProjects =
            3; // Show 3 projects initially on "Show Less"
      } else {
        initiallyDisplayedProjects =
            allProjects!.length; // Show all projects on "Show More"
      }
      showAllProjects = !showAllProjects;
    });
  }

  // Calculate the number of projects per row based on the screen width and desired project card width
  int calculateProjectsPerRow(BuildContext context, double cardWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / cardWidth).floor();
  }

  @override
  Widget build(BuildContext context) {
    // Inside the build method, calculate the projects per row and adjust spacing accordingly
    double cardWidth = 250; // Adjust the desired project card width
    double cardHeight = 250; // Adjust the desired project card height
    int projectsPerRow = calculateProjectsPerRow(
        context, cardWidth); // Adjust the desired project card width
    // final screenWidth = MediaQuery.of(context).size.width;
    // bool _isSvgHovered = false;

    // double titleFontSize = screenWidth * 0.05;
    // double descriptionFontSize = screenWidth * 0.01;
    // double spacing = screenWidth * 0.15;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: Text(
                    'Personal Projects',
                    style: PublicViewTextStyles.generalHeading.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    // style: TextStyle(
                    //   fontSize: 40,
                    //   fontFamily: 'Montserrat',
                    //   fontWeight: FontWeight.bold,
                    // ),
                  ),
                ),
              ),
              const SizedBox(
                  width: 200), // Add some spacing between title and quote
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(
                      right: 150.0), // Change padding for quote
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(5.0), // Border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(
                              0.2), // Adjust shadow color and opacity
                          spreadRadius: 2, // Adjust the spread radius
                          blurRadius: 5, // Adjust the blur radius
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      color: Colors.white, // Background color
                      child: Text(
                        sectionDescription,
                        textAlign: TextAlign.left,
                        softWrap: true,
                        style: PublicViewTextStyles.generalBodyText.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        // style: TextStyle(
                        //   fontSize: 18,
                        //   fontFamily: 'Roboto',
                        //   fontWeight: FontWeight.w300,
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 60), // Space between title and projects
        Center(
          child: Column(
            children: [
              if (allProjects != null)
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children:
                        List.generate(initiallyDisplayedProjects, (index) {
                      if (index < allProjects!.length) {
                        // Calculate spacing for the staggered effect
                        double spacing = (index % (projectsPerRow - 1)) * 50.0;
                        return Padding(
                          padding: EdgeInsets.only(top: spacing, right: 50),
                          child: SizedBox(
                            width: cardWidth,
                            height: cardHeight,
                            child: Card(
                              elevation: 3,
                              color: getNextColor(),
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allProjects![index].name!,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      allProjects![index].description!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: GestureDetector(
                                          onTap: () {
                                            if (allProjects![index].link !=
                                                null) {
                                              openLink(
                                                  allProjects![index].link!);
                                            } else {
                                              log('Link is null.');
                                            }
                                          },
                                          child: MouseRegion(
                                            cursor: SystemMouseCursors.click,
                                            child: GestureDetector(
                                              onTap: () {
                                                if (allProjects![index].link !=
                                                    null) {
                                                  openLink(allProjects![index]
                                                      .link!);
                                                } else {
                                                  log('Link is null.');
                                                }
                                              },
                                              child: SvgPicture.asset(
                                                'external_link.svg',
                                                width: 50,
                                                height: 50,
                                                // color: Colors.black,
                                              ),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(); // Empty container if index exceeds project count
                      }
                    }),
                  ),
                ),
              const SizedBox(height: 50),
              if (allProjects != null &&
                  allProjects!.length > initiallyDisplayedProjects)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 375.0, bottom: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              // Change the style on hover
                              _isHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              // Revert the style when not hovered
                              _isHovered = false;
                            });
                          },
                          child: TextButton(
                            onPressed: toggleShowAllProjects,
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.keyboard_double_arrow_down_outlined,
                                    size: 30,
                                    color: Colors.black),
                                const SizedBox(width: 5),
                                Text(
                                  'Load More',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: _isHovered
                                        ? Colors.black
                                        : Colors
                                            .black, // Change text color on hover
                                    decoration: _isHovered
                                        ? TextDecoration.underline
                                        : TextDecoration
                                            .none, // Underline on hover
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              if (showAllProjects)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 375.0, bottom: 16.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MouseRegion(
                          onEnter: (_) {
                            setState(() {
                              // Change the style on hover
                              _isHovered = true;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              // Revert the style when not hovered
                              _isHovered = false;
                            });
                          },
                          child: TextButton(
                            onPressed: toggleShowAllProjects,
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              padding:
                                  MaterialStateProperty.all(EdgeInsets.zero),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                    Icons.keyboard_double_arrow_up_outlined,
                                    size: 30,
                                    color: Colors.black),
                                const SizedBox(width: 5),
                                Text(
                                  'Load Less',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black, // Change text color
                                    decoration: _isHovered
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: openCustomLink,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 150.0, bottom: 150.0),
                    child: SvgPicture.asset(
                      'github.svg', // Replace with the path to your SVG file
                      width: 250,
                      height: 250,
                      // color: Colors.transparent,
                    ),
                  ),
                ),
              ),
              if (allProjects == null)
                const Text(
                  'Error loading projects.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
