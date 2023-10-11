import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/models/AboutAss.dart';
import '../constants.dart';
import '../controllers/admin_controllers/about_ass_section_admin_controller.dart';
import 'package:avantswift_portfolio/reposervice/about_ass_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';

class AboutAssDialog extends StatefulWidget {
  static const double largeSizedBoxHeight = 16;
  static const double smallSizedBoxHeight = 8;
  static const double generalPadding = 16.0;
  static const double imageWidth = 200;
  static const double imageHeight = 300;
  const AboutAssDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AboutAssDialogState createState() => _AboutAssDialogState();
}

class _AboutAssDialogState extends State<AboutAssDialog> {
  final AboutAssSectionAdminController _controller =
      AboutAssSectionAdminController(AboutAssRepoService());

  List<AboutAss> _aboutAssList = [];
  int _currentIndex = 0;
  late AboutAss _currentAboutAss;

  @override
  void initState() {
    super.initState();
    _loadAboutAssData();
  }

  Future<void> _loadAboutAssData() async {
    final aboutAssList = await _controller.getAboutAssSectionData();
    if (aboutAssList != null) {
      setState(() {
        _aboutAssList = aboutAssList;
        _currentAboutAss = _aboutAssList[0]; // Initialize with the first item
      });
    }
  }

  void _previousPage() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _currentAboutAss = _aboutAssList[_currentIndex];
      }
    });
  }

  void _nextPage() {
    setState(() {
      if (_currentIndex < (_aboutAssList.length) - 1) {
        _currentIndex++;
        _currentAboutAss = _aboutAssList[_currentIndex];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      // Apply the theme to the entire AlertDialog and its contents
      data: AdminViewDialogStyles.dialogThemeData,
      child: AlertDialog(
        titlePadding: AdminViewDialogStyles.titleDialogPadding,
        contentPadding: AdminViewDialogStyles.contentDialogPadding,
        actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
        title: Container(
          padding: AdminViewDialogStyles.titleContPadding,
          color: AdminViewDialogStyles.bgColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('About AvantSwift Solutions'),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.close),
                      iconSize: AdminViewDialogStyles.closeIconSize,
                      hoverColor: Colors.transparent,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AboutAssDialog.largeSizedBoxHeight),
              const Divider(),
              const SizedBox(height: AboutAssDialog.largeSizedBoxHeight),
            ],
          ),
        ),
        content: SizedBox(
          height: AdminViewDialogStyles.aboutAssDialogHeight,
          width: AdminViewDialogStyles.aboutAssDialogWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_aboutAssList.isNotEmpty)
                Expanded(
                  child: PageView.builder(
                    itemCount: _aboutAssList.length,
                    controller: PageController(initialPage: _currentIndex),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                        _currentAboutAss = _aboutAssList[_currentIndex];
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding:
                            const EdgeInsets.all(AboutAssDialog.generalPadding),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_currentAboutAss.name}',
                                    style:
                                        AdminViewDialogStyles.buttonTextStyle,
                                  ),
                                  const SizedBox(
                                      height:
                                          AboutAssDialog.smallSizedBoxHeight),
                                  Text(
                                    '${_currentAboutAss.description}',
                                    style:
                                        AdminViewDialogStyles.buttonTextStyle,
                                  ),
                                  const SizedBox(
                                      height:
                                          AboutAssDialog.smallSizedBoxHeight),
                                ],
                              ),
                            ),
                            Image.network(
                              _currentAboutAss.imageURL != null &&
                                      _currentAboutAss.imageURL!.isNotEmpty
                                  ? _currentAboutAss.imageURL!
                                  : Constants.replaceImageURL,
                              width: AboutAssDialog.imageWidth,
                              height: AboutAssDialog.imageHeight,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: const Icon(Icons.arrow_back),
                  ),
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: const Icon(Icons.arrow_forward),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
