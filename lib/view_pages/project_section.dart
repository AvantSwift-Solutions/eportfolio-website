import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../controllers/view_controllers/project_section_controller.dart';
import '../models/Project.dart';
import '../reposervice/project_repo_services.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class ProjectSection extends StatefulWidget {
  const ProjectSection({Key? key}) : super(key: key);

  @override
  ProjectSectionState createState() => ProjectSectionState();
}

class ProjectSectionState extends State<ProjectSection> {
  final ProjectSectionController _projectController =
      ProjectSectionController(ProjectRepoService());
  List<Project>? allProjects;
  bool showAllProjects = false;
  int initiallyDisplayedProjects = 3;
  int colorIndex = 0;
  final List<Color> alternatingColors = [
    Colors.orange.shade200,
    Colors.blue.shade200,
    Colors.green.shade200
  ];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final List<Project>? fetchedProjects =
          await _projectController.getProjectList();
      setState(() {
        allProjects = fetchedProjects;
      });
    } catch (e) {
      print('Error fetching projects: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  Color getNextColor() {
    Color nextColor = alternatingColors[colorIndex];
    colorIndex = (colorIndex + 1) % alternatingColors.length;
    return nextColor;
  }

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('Could not launch $link');
    }
  }

  void openCustomLink() async {
    const url = 'https://example.com'; // Replace with your desired URL (github)
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      print('Could not launch $url');
    }
  }

  void toggleShowAllProjects() {
    setState(() {
      if (showAllProjects) {
        initiallyDisplayedProjects = 3; // Show 3 projects initially on "Show Less"
      } else {
        initiallyDisplayedProjects =
            allProjects!.length; // Show all projects on "Show More"
      }
      showAllProjects = !showAllProjects;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 200), // Add some spacing between title and quote
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: 150.0), // Change padding for quote
                  child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1.0),
                    borderRadius: BorderRadius.circular(5.0), // Border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2), // Adjust shadow color and opacity
                        spreadRadius: 2, // Adjust the spread radius
                        blurRadius: 5, // Adjust the blur radius
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  width: 300,
                  // height: 200,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.white, // Background color
                    child: Text(
                      '"I enjoy working on projects during my personal time as it provides an opportunity to experiment with something new and continuously enrich my current skill-set."',
                      textAlign: TextAlign.left,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20), // Space between title and projects
        Center(
          child: Column(
            children: [
              if (allProjects != null)
                Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: List.generate(initiallyDisplayedProjects, (index) {
                      if (index < allProjects!.length) {
                        // Calculate spacing for the staggered effect
                        double spacing = (index + 1) * 50.0;
                        return Padding(
                          padding: EdgeInsets.only(top: spacing, right: 50),
                          child: Container(
                            width: 250,
                            height: 250,
                            child: Card(
                              elevation: 3,
                              color: getNextColor(),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      allProjects![index].name!,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      allProjects![index].description!,
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton(
                                        onPressed: () => openLink(allProjects![index].link!),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey,
                                        ),
                                        child: Icon(Icons.link),
                                      ),
                                    ),
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
                    child: ElevatedButton(
                      onPressed: toggleShowAllProjects,
                      child: Text('Show More'),
                    ),
                  ),
                ),
              const SizedBox(height: 30),
              if (showAllProjects)
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 375.0, bottom: 16.0),
                    child: ElevatedButton(
                      onPressed: toggleShowAllProjects,
                      child: Text('Show Less'),
                    ),
                  ),
                ),
              Align(
                alignment: Alignment.bottomLeft,
                child: GestureDetector(
                  onTap: openCustomLink,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 150.0, bottom: 50.0),
                    child: Container(
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Text(
                        'View all my projects!',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (allProjects == null)
                Text(
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
