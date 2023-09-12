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

        double titleFontSize = screenWidth * 0.03;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ExperienceWidget(experienceIndex: 0),
              ExperienceWidget(experienceIndex: 1),
            ],
          ),
        );

        // return Center(
        //   child: Padding(
        //       padding: const EdgeInsets.all(50.0),
        //       child: ExperienceWidget(experienceIndex: 0),
        //       ),
        // );
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

        double titleFontSize = screenWidth * 0.03;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Job Title: ${experienceDTO.jobTitle}',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Company: ${experienceDTO.companyName}',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Location: ${experienceDTO.location}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Start Date: ${experienceDTO.startDate?.toDate().toString() ?? "Unknown"}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'End Date: ${experienceDTO.endDate?.toDate().toString() ?? "Unknown"}',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Description: ${experienceDTO.description}',
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        );
      },
    );
  }
}
