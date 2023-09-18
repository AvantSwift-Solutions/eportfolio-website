import 'package:flutter/material.dart';

import '../controllers/view_controllers/technical_skills_controller.dart';
import '../reposervice/tskill_repo_services.dart';
import '../ui/tskill_image.dart';

class TechnicalSkillsWidget extends StatefulWidget {
  const TechnicalSkillsWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TechnicalSkillsWidgetState createState() => _TechnicalSkillsWidgetState();
}

class _TechnicalSkillsWidgetState extends State<TechnicalSkillsWidget> {
  final TechnicalSkillsController _technicalSkillsController =
      TechnicalSkillsController(TSkillRepoService());
  List<Image> defaultSurroundingImages = [];
  Image? centreImage;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    defaultSurroundingImages =
        await _technicalSkillsController.getTechnicalSkillImagesGivenPage(1);
    centreImage = await _technicalSkillsController.getCentralImage();
    // Ensure that the widget rebuilds after loading the images
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
    
        width: 1000, // Adjust the size as needed
        height: 1000, // Adjust the size as needed
        child: centreImage != null
            ? TSkillsImage(
                surroundingImages: defaultSurroundingImages,
                centerImage: centreImage!,
              )
            : const CircularProgressIndicator(), // Show a loading indicator
      ),
    );
  }
}
