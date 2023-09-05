import 'package:avantswift_portfolio/models/PersonalProject.dart';

class PersonalProjectList {
  final List<PersonalProject> projects;

  // PersonalProjectList(this.projects);

  PersonalProjectList.fromList(List<PersonalProject>? projectList)
    : projects = projectList ?? [];

  // void addProject(PersonalProject project) {
  //   projects.add(project);
  // }


  // Future<void> createInFirestore() async {
  //   try {
  //     final batch = FirebaseFirestore.instance.batch();
  //     for (final project in projects) {
  //       batch.set(
  //         FirebaseFirestore.instance.collection('PersonalProject').doc(project.ppid),
  //         project.toMap(),
  //       );
  //     }
  //     await batch.commit();
  //     print('Personal project documents created in Firestore');
  //   } catch (e) {
  //     print('Error creating personal project documents in Firestore: $e');
  //   }
  // }
}