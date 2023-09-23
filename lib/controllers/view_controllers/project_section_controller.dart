import 'dart:developer';

import '../../models/Project.dart';
import '../../reposervice/project_repo_services.dart';

class ProjectSectionController {
  final ProjectRepoService projectRepoService;

  ProjectSectionController(this.projectRepoService); // Constructor

  Future<List<Project>?> getProjectList() async {
    try {
      List<Project>? projects = await projectRepoService.getAllProjects();
      return projects;
    } catch (e) {
      log('Error getting  project list: $e');
      return null;
    }
  }
}
