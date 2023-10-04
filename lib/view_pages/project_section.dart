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
  bool isHovered = false;
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
    double minCardWidth = 150;
    cardWidth = screenWidth < minCardWidth ? minCardWidth : cardWidth;
    return (screenWidth / cardWidth).floor();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 600;

    double cardWidth = 250;
    double cardHeight = 250;

    int projectsPerRow = calculateProjectsPerRow(context, cardWidth);

    double titleFontSize = isMobileView ? screenWidth * 0.08 : screenWidth * 0.05;
    double descriptionFontSize = isMobileView ? screenWidth * 0.03 : screenWidth * 0.015;
    double gap = screenWidth * 0.11;
    double titlePadding = screenWidth * 0.05;
    double descriptionPadding = screenWidth * 0.05;

  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobileView)
          Container(
            margin: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Personal Projects',
              style: PublicViewTextStyles.generalHeading.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize * 0.8,
              ),
            ),
          ),
          const SizedBox(height: 25),
        if (isMobileView)
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                sectionDescription,
                textAlign: TextAlign.left,
                softWrap: true,
                style: PublicViewTextStyles.generalBodyText.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: descriptionFontSize * 1.3,
                ),
              ),
            ),
          ),
        if (!isMobileView)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: titlePadding), // Add padding here
                child: Text(
                  'Personal Projects',
                  style: PublicViewTextStyles.generalHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize * 0.8,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: descriptionPadding),
                child: Container(
                  width: screenWidth * 0.4,
                  margin: EdgeInsets.only(top: isMobileView ? 16.0 : 0.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      sectionDescription,
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: PublicViewTextStyles.generalBodyText.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: descriptionFontSize * 1.0,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        const SizedBox(height: 25),
          if (allProjects != null && !isMobileView)
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: List.generate(initiallyDisplayedProjects, (index) {
                  if (index < allProjects!.length) {
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
                            side: const BorderSide(color: Colors.black, width: 1),
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
                                      if (allProjects![index].link != null) {
                                        openLink(allProjects![index].link!);
                                      } else {
                                        log('Link is null.');
                                      }
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (allProjects![index].link != null) {
                                            openLink(allProjects![index].link!);
                                          } else {
                                            log('Link is null.');
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'external_link.svg',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
          const SizedBox(height: 50),
          if (allProjects != null && !isMobileView && allProjects!.length > initiallyDisplayedProjects)
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
                          isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered = false;
                        });
                      },
                      child: TextButton(
                        onPressed: toggleShowAllProjects,
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
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
                                color: isHovered ? Colors.black : Colors.black,
                                decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
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
          if (showAllProjects && !isMobileView)
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
                          isHovered = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          isHovered = false;
                        });
                      },
                      child: TextButton(
                        onPressed: toggleShowAllProjects,
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(Colors.transparent),
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
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
                                color: Colors.black,
                                decoration: isHovered ? TextDecoration.underline : TextDecoration.none,
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
          if (isMobileView && allProjects != null)
            Center(
              child: Column(
                children: List.generate(initiallyDisplayedProjects, (index) {
                  if (index < allProjects!.length) {
                    double spacing = (index % (projectsPerRow)) * 50.0;
                    return Padding(
                      padding: EdgeInsets.only(top: spacing),
                      child: SizedBox(
                        width: cardWidth,
                        height: cardHeight,
                        child: Card(
                          elevation: 3,
                          color: getNextColor(),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.black, width: 1),
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
                                      if (allProjects![index].link != null) {
                                        openLink(allProjects![index].link!);
                                      } else {
                                        log('Link is null.');
                                      }
                                    },
                                    child: MouseRegion(
                                      cursor: SystemMouseCursors.click,
                                      child: GestureDetector(
                                        onTap: () {
                                          if (allProjects![index].link != null) {
                                            openLink(allProjects![index].link!);
                                          } else {
                                            log('Link is null.');
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'external_link.svg',
                                          width: 50,
                                          height: 50,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
              ),
            ),
          if (isMobileView)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: toggleShowAllProjects,
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        showAllProjects
                            ? Icons.keyboard_double_arrow_up_outlined
                            : Icons.keyboard_double_arrow_down_outlined,
                        size: 30,
                        color: Colors.black,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        showAllProjects ? 'Load Less' : 'Load More',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 30),
          if (isMobileView)
            Center(
              child: GestureDetector(
                onTap: openCustomLink,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: SvgPicture.asset(
                    'github.svg',
                    width: 250,
                    height: 250,
                  ),
                ),
              ),
            ),
          if (!isMobileView)
            Align(
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: openCustomLink,
                child: Padding(
                  padding: EdgeInsets.only(left: gap, bottom: 16.0),
                  child: SvgPicture.asset(
                    'github.svg',
                    width: 250,
                    height: 250,
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
    );
  }
}
