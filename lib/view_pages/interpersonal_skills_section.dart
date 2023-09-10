import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter/material.dart';

class InterpersonalSkillsWidget extends StatefulWidget {
  @override
  _InterpersonalSkillsWidgetState createState() =>
      _InterpersonalSkillsWidgetState();
}

class _InterpersonalSkillsWidgetState extends State<InterpersonalSkillsWidget> {
  final List<List<String>> skills = [
    ["Skill 1", "Skill 2", "Skill 3", "Skill 4", "Skill 5", "Skill 6"],
    ["Skill 7", "Skill 8", "Skill 9", "Skill 10", "Skill 11", "Skill 12"],
    ["Skill 13", "Skill 14"],
  ];

  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    double maxWidgetWidth = 400;

    return Container(
      width: maxWidgetWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Interpersonal Skills',
                  style: PublicViewTextStyles.generalSubHeading,
                  textAlign: TextAlign.left,
                ),
                const Divider(
                  color: Colors.black,
                  thickness: 2.0,
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity, // Expand to the maximum available width
            height: 180,
            child: SizedBox(
              height: 10, // Adjust the height as needed
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemCount: skills.length,
                itemBuilder: (context, pageIndex) {
                  final pageSkills = skills[pageIndex];
                  const numColumns = 2;
                  final skillsPerColumn = pageSkills.length ~/ numColumns;
                  return ListView.builder(
                    padding: const EdgeInsets.all(5),
                    itemCount: skillsPerColumn,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          for (int i = 0; i < numColumns; i++)
                            Flexible(
                              child: ListTile(
                                leading: Icon(Icons.circle_outlined, size: 10),
                                title: Text(
                                  pageSkills[index * numColumns + i],
                                  textAlign: TextAlign
                                      .left, // Align the text to the right
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
          if (skills.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(
                skills.length,
                (index) => GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 10,
                    height: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5),
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
