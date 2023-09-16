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

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('Could not launch $link');
    }
  }

  void toggleShowAllProjects() {
    setState(() {
      // Toggle the state to show all projects or just the first three
      showAllProjects = !showAllProjects;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Projects',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              if (allProjects != null)
                Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    for (var project in allProjects!.take(showAllProjects
                        ? allProjects!.length
                        : 3))
                      Container(
                        width: 300, // Fixed width for each project card
                        margin:
                            EdgeInsets.all(10), // Add some margin between cards
                        child: Card(
                          elevation: 3, // Add elevation for a shadow effect
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  project.name!,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  project.description!,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () => openLink(project.link!),
                                  child: Text('Visit Project'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              if (allProjects != null &&
                  (!showAllProjects && allProjects!.length > 3))
                ElevatedButton(
                  onPressed: toggleShowAllProjects,
                  child: Text('Show More'),
                ),
              if (showAllProjects)
                ElevatedButton(
                  onPressed: toggleShowAllProjects,
                  child: Text('Show Less'),
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
