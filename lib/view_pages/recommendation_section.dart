import 'dart:developer';

import 'package:avantswift_portfolio/constants.dart';
import 'package:avantswift_portfolio/controllers/view_controllers/recommendation_section_controller.dart';
import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecommendationSection extends StatefulWidget {
  final RecommendationSectionController? controller;
  const RecommendationSection({Key? key, this.controller}) : super(key: key);

  @override
  RecommendationSectionState createState() => RecommendationSectionState();
}

class RecommendationSectionState extends State<RecommendationSection> {
  late RecommendationSectionController _recommendationSectionController;
  List<Recommendation>? recommendations;
  final PageController _pageController =
      PageController(viewportFraction: 1.0, initialPage: 0);
  // static const int recommendationsPerPage = 3;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _recommendationSectionController = widget.controller ??
        RecommendationSectionController(RecommendationRepoService());
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page?.toInt() ?? 0;
      });
    });

    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final List<Recommendation>? fetchedRecommendations =
          await _recommendationSectionController.getRecommendationSectionData();
      setState(() {
        recommendations = fetchedRecommendations;
      });
    } catch (e) {
      log('Error fetching awards and certificates: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      log('Could not launch $link');
    }
  }
  int calculateRecommendationsPerPage(double recommendationItemHeight, double recommendationSectionHeight) {
    // Calculate the maximum recommendations per page based on available height
    return (recommendationSectionHeight / recommendationItemHeight).floor();
  }

  @override
  Widget build(BuildContext context) {
    // int totalPages =
    //     (recommendations?.length ?? 0) ~/ recommendationsPerPage + 1;
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height;
    bool isMobileView = screenWidth <= 600;

    double recommendationTitleFontSize =
        isMobileView ? screenWidth * 0.07 : screenWidth * 0.03;
    double recommendationSectionWidth = 
        isMobileView ? screenWidth * 0.9 : screenWidth * 0.5;
    double recommendationSectionHeight = 
        isMobileView ? screenWidth * 0.9 : screenWidth * 0.4;
    
    double generalPadding = 
        isMobileView ? 20 : 15;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: generalPadding),
          child: Text(
            'Peer Recommendations',
            style: TextStyle(
              fontSize: recommendationTitleFontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: generalPadding, right: generalPadding),
          width: recommendationSectionWidth,
          child: const Divider(
            height: 1.0, // Height of the divider line
            color: Colors.black, // Color of the divider line
          ),
        ),
        // SingleChildScrollView(
        SizedBox(
          height: recommendationSectionHeight,
          child: ListView(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: recommendations?.length ?? 0,
          itemBuilder: (context, index) {
            Recommendation recommendation = recommendations![index];
            return _buildRecommendationTile(recommendation);
          },
        ),
      ],
      ),
        ),
        // if ((recommendations?.length ?? 0) > 3)
        //   SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     child: Row(
        //       children: [
        //         for (int i = 3; i < (recommendations?.length ?? 0); i++)
        //           _buildRecommendationTile(recommendations![i]),
        //       ],
        //     ),
        //   ),
      ],
    );
  }



  // Widget _buildPageIndicator(bool isActive, int pageIndex) {
  //   double buttonWidth = 8;
  //   double buttonRadius = buttonWidth / 2;

  //   return GestureDetector(
  //     onTap: () {
  //       // Move the page view to the tapped page
  //       _pageController.animateToPage(
  //         pageIndex,
  //         duration: const Duration(milliseconds: 500),
  //         curve: Curves.ease,
  //       );
  //     },
  //     child: Container(
  //       margin: const EdgeInsets.symmetric(horizontal: 4.0),
  //       height: buttonWidth,
  //       width: isActive ? buttonWidth : buttonWidth,
  //       decoration: BoxDecoration(
  //         color: isActive ? Colors.blue : Colors.grey,
  //         borderRadius: BorderRadius.circular(buttonRadius),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildRecommendationTile(Recommendation recommendation) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 600;
    
    double imageRadius = 
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.01;

    double recommendationDescriptionFontSize =
        isMobileView ? screenWidth * 0.02 : screenWidth * 0.01;
    double recommendationNameFontSize =
        isMobileView ? screenWidth * 0.025 : screenWidth * 0.01;
    double recommendationJobTitleFontSize =
        isMobileView ? screenWidth * 0.025 : screenWidth * 0.01;
    double recommendationSectionWidth = 
        isMobileView ? screenWidth * 0.9 : screenWidth * 0.5;
    double generalPadding = 
        isMobileView ? 20 : 15;
    double offset = 
        isMobileView ? screenWidth * 0.1 : screenWidth * 0.003;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: recommendationSectionWidth,
          child:ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: imageRadius,
                  backgroundImage: NetworkImage(
                      recommendation.imageURL ?? Constants.replaceImageURL),
                ),
                SizedBox(width: generalPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                        // constraints: BoxConstraints(
                          // maxWidth: recommendationSectionWidth,
                        // ),
                        Text(
                          '"${recommendation.description}"',
                          style: TextStyle(
                            fontSize: recommendationDescriptionFontSize,
                          ),
                        ),
                      // ),
                      Text(
                        recommendation.colleagueName ?? 'Colleague Name',
                        style: TextStyle(
                          fontSize: recommendationNameFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        recommendation.colleagueJobTitle ?? 'Job Title',
                        style: TextStyle(
                          fontSize: recommendationJobTitleFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),        
        Padding(
          padding: EdgeInsets.only(left: generalPadding , right: generalPadding + offset),
          child: SizedBox(
            width: recommendationSectionWidth,
            child: const Divider(
              height: 1.0, // Height of the divider line
              color: Colors.black, // Color of the divider line
            ),
          ),
        )
      ],
    );
  }
}
