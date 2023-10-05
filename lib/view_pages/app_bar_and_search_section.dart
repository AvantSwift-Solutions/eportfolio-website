import 'package:avantswift_portfolio/controllers/view_controllers/search_section_controller.dart';
import 'package:avantswift_portfolio/dto/section_keys_dto.dart';
import 'package:avantswift_portfolio/dto/section_results_dto.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter/material.dart';

class AppBarAndSearchSection extends StatefulWidget {
  final Function(GlobalKey) scrollToSection;
  final SearchSectionController controller = SearchSectionController();
  final SectionKeysDTO sectionKeys;
  AppBarAndSearchSection(
      {Key? key, required this.sectionKeys, required this.scrollToSection})
      : super(key: key);

  @override
  State<AppBarAndSearchSection> createState() => _AppBarAndSearchSectionState();
}

class _AppBarAndSearchSectionState extends State<AppBarAndSearchSection> {
  String selectedResult = ''; // Store the selected result here
  List<SectionResultDTO> searchResults = []; // Store the search results here
  String currentQuery = '';
  void updateSearchResults(String text) async {
    // Call the controller's searchDatabase method and await the result
    List<SectionResultDTO> results =
        await widget.controller.searchDatabase(text);

    setState(() {
      searchResults = results; // Update the search results
    });
  }

  void scrollToSection(Sections sectionName) {
    GlobalKey? sectionKey;

    // Determine the appropriate sectionKey based on the sectionName
    switch (sectionName) {
      case Sections.Experience:
        sectionKey = widget.sectionKeys.experience;
        break;
      case Sections.AboutMe:
        sectionKey = widget.sectionKeys.aboutMe;
        break;
      case Sections.TSkill:
        sectionKey = widget.sectionKeys.skillsEdu;
        break;
      case Sections.ISkill:
        sectionKey = widget.sectionKeys.skillsEdu;
        break;
      case Sections.Education:
        sectionKey = widget.sectionKeys.skillsEdu;
        break;
      case Sections.Projects:
        sectionKey = widget.sectionKeys.projects;
        break;
      case Sections.AwardsCerts:
        sectionKey = widget.sectionKeys.awardsCerts;
        break;
      case Sections.Contact:
        sectionKey = widget.sectionKeys.contact;
        break;
      case Sections.Default:
        sectionKey = widget.sectionKeys.aboutMe;
      case Sections.Recommendation:
        sectionKey = widget.sectionKeys.awardsCerts;
        // Handle unknown section names if needed
        break;
    }
    // Scroll to the section if the key is found
    widget.scrollToSection(sectionKey);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate padding based on screen width
    double horizontalPadding = screenWidth < 600 ? 8.0 : 106.0;

    return AppBar(
      backgroundColor: const Color.fromRGBO(253, 252, 255, 1.0),
      // pinned: true,
      scrolledUnderElevation: 0,
      centerTitle: false,
      title: Row(
        children: [
          const Text(
            'Steven.Zhou',
            style: TextStyle(
              fontSize: 24.0, // Adjust the font size as needed
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Container(
              width: 170.0, // Adjust the width as needed
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: Colors.black, // Border color
                  width: 1.4, // Border width
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        onChanged: (text) {
                          currentQuery = text;
                          // Call the async method to update search results
                        },
                        decoration: InputDecoration(
                          hintStyle: PublicViewTextStyles.generalBodyText,
                          hintText: 'Search', // Left-aligned hintText
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  MenuAnchor(
                    alignmentOffset: const Offset(-150, 5),
                    menuChildren: searchResults.map((result) {
                      return MenuItemButton(
                        onPressed: () => setState(() {
                          scrollToSection(result.section);
                          setState(() {
                            selectedResult = result.sectionName;
                          });
                        }),
                        child: Text(
                          result.sectionName,
                          style: PublicViewTextStyles.generalBodyText,
                        ),
                      );
                    }).toList(),
                    builder: (BuildContext context, MenuController controller,
                        Widget? child) {
                      return IconButton(
                        onPressed: () {
                          updateSearchResults(currentQuery);
                          if (controller.isOpen) {
                            controller.close();
                          } else {
                            controller.open();
                          }
                        },
                        icon: const Icon(Icons.search),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}