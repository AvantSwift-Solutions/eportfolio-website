import 'package:avantswift_portfolio/controllers/view_controllers/search_section_controller.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter/material.dart';

class AppBarAndSearchSection extends StatefulWidget {
  final SearchSectionController controller = SearchSectionController();

  AppBarAndSearchSection({Key? key}) : super(key: key);

  @override
  State<AppBarAndSearchSection> createState() => _AppBarAndSearchSectionState();
}

enum SampleItem { itemOne, itemTwo, itemThree }

class _AppBarAndSearchSectionState extends State<AppBarAndSearchSection> {
  String selectedResult = ''; // Store the selected result here
  List<String> searchResults = []; // Store the search results here

  void updateSearchResults(String text) async {
    // Call the controller's searchDatabase method and await the result
    List<String> results = await widget.controller.searchDatabase(text);

    setState(() {
      searchResults = results; // Update the search results
    });
  }

  SampleItem? selectedMenu;

  @override
  Widget build(BuildContext context) {
    return AppBar(
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
            padding: const EdgeInsets.symmetric(
                horizontal: 46.0), // Adjust the padding as needed
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
                        updateSearchResults(
                            text); // Call the async method to update search results
                      },
                      decoration: InputDecoration(
                        hintStyle: PublicViewTextStyles.generalBodyText,
                        hintText: 'Search', // Left-aligned hintText
                        border: InputBorder.none,
                      ),
                    ),
                  )),
                  MenuAnchor(
                      alignmentOffset: const Offset(-100, 5),
                      menuChildren: searchResults.map((result) {
                        return MenuItemButton(
                          onPressed: () => setState(() {
                            selectedResult = result;
                          }),
                          child: Text(
                            result,
                            style: PublicViewTextStyles.generalBodyText,
                          ),
                        );
                      }).toList(),
                      builder: (BuildContext context, MenuController controller,
                          Widget? child) {
                        return IconButton(
                            onPressed: () {
                              if (controller.isOpen) {
                                controller.close();
                              } else {
                                controller.open();
                              }
                            },
                            icon: const Icon(Icons.search));
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
