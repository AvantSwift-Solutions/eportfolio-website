// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:avantswift_portfolio/controllers/view_controllers/interpersonal_skills_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter/material.dart';

class InterpersonalSkillsWidget extends StatefulWidget {
  final InterpersonalSkillsController? controller;
  const InterpersonalSkillsWidget({Key? key, this.controller})
      : super(key: key);

  @override
  _InterpersonalSkillsWidgetState createState() =>
      _InterpersonalSkillsWidgetState();
}

class _InterpersonalSkillsWidgetState extends State<InterpersonalSkillsWidget> {
  late InterpersonalSkillsController _interpersonalSkillsController;
  List<String> skills = [];

  @override
  void initState() {
    super.initState();
    _interpersonalSkillsController =
        widget.controller ?? InterpersonalSkillsController(ISkillRepoService());
    fetchData();
  }

  Future<void> fetchData() async {
    // Assuming getIPersonalSkills is an async function that returns a List<String>
    final skillsData =
        await _interpersonalSkillsController.getIPersonalSkills();

    if (skillsData != null) {
      setState(() {
        skills = skillsData;
      });
    }
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double maxWidgetWidth = 400;
    double screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 600;
    double titleFontSize = 
        isMobileView ? screenWidth * 0.06 : screenWidth * 0.02;
    double skillsFontSize = 
        isMobileView ? screenWidth * 0.04 : screenWidth * 0.012;
    double circleSize = 
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.01;
    double iskillsSectionHeight =
        isMobileView ? screenWidth * 0.4 : screenWidth * 0.2;
    double iskillsSectionHeight2 = screenWidth * 0.3;

    return SizedBox(
      width: maxWidgetWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interpersonal Skills',
                  style: PublicViewTextStyles.generalSubHeading.copyWith(
                    fontSize: titleFontSize
                  ),
                  textAlign: TextAlign.left,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity, // Expand to the maximum available width
            height: (screenWidth < 1000 && screenWidth > 600) ? iskillsSectionHeight2 : iskillsSectionHeight,
            child: SizedBox(
              height: 10, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: ((skills.length + 5) / 6)
                    .floor(), // Display up to 6 skills per page
                itemBuilder: (context, pageIndex) {
                  final startIndex = pageIndex * 6;
                  final endIndex = (startIndex + 6).clamp(0, skills.length);
                  final pageSkills = skills.sublist(startIndex, endIndex);
                  const numColumns = 2;
                  final skillsPerColumn =
                      (pageSkills.length / numColumns).ceil();
                  return ListView.builder(
                    padding:
                        EdgeInsets.zero, // Remove padding around the ListTile
                    itemCount: skillsPerColumn,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < numColumns; i++)
                            if (index * numColumns + i < pageSkills.length)
                              Flexible(
                                child: Container(
                                  padding: const EdgeInsets.all(
                                      4.0), // Adjust padding as needed
                                  child: ListTile(
                                    contentPadding: EdgeInsets
                                        .zero, // Remove ListTile's default content padding
                                    leading: Icon(Icons.circle_outlined,
                                        size: circleSize),
                                    title: Text(
                                      pageSkills[index * numColumns + i],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: skillsFontSize,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          if (skills.length > 6)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                ((skills.length + 5) / 6).floor(),
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
