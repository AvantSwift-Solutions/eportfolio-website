// import 'package:avantswift_portfolio/dto/personal_project_dto.dart';
// import 'package:avantswift_portfolio/models/personal_project.dart';
// import 'package:avantswift_portfolio/reposervice/personal_project_repo_services.dart';

// import '../../reposervice/user_repo_services.dart';

// class PersonalProjectController {
//   final UserRepoService userRepoService;

//   PersonalProjectController(this.userRepoService); // Constructor

//   Future<PersonalProjectDTO>? getPersonalProjectData() async {
//     try {
//       PersonalProject? personalProject = await PersonalProjectRepoService.getAllProjects();
//       if (personalProject != null) {
//         return PersonalProjectDTO(
//           name: personalProject.name,
//           description: personalProject.description,
//           imageURL: personalProject.imageURL,
//         );
//       } else {
//         return PersonalProjectDTO(
//           name: 'Unknown',
//           description: 'No description available',
//           imageURL: 'https://example.com/default_image.jpg',
//         );
//       }
//     } catch (e) {
//       return PersonalProjectDTO(
//         name: 'Error',
//         description: 'Error',
//         imageURL: 'https://example.com/default_image.jpg',
//       );
//     }
//   }
// }
