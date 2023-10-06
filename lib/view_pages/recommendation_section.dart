import 'dart:developer';

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
  static const int recommendationsPerPage = 3;
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

  @override
  Widget build(BuildContext context) {
    int totalPages =
        (recommendations?.length ?? 0) ~/ recommendationsPerPage + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Peer Recommendations',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(left: 20.0),
          width: 625,
          child: const Divider(
            height: 1.0, // Height of the divider line
            color: Colors.black, // Color of the divider line
          ),
        ),
        SizedBox(
          height: 900, // Changed it manually due to RenderFlex overflow
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, pageIndex) {
              int startIndex = pageIndex * recommendationsPerPage;
              int endIndex = (pageIndex + 1) * recommendationsPerPage;
              endIndex = endIndex < (recommendations?.length ?? 0)
                  ? endIndex
                  : (recommendations?.length ?? 0);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  if (recommendations != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recommendations!
                            .sublist(startIndex, endIndex)
                            .map((recommendation) =>
                                _buildRecommendationTile(recommendation))
                            .toList(),
                      ),
                    ),
                  if (recommendations == null)
                    const Text(
                      'Error loading recommendations.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < totalPages; i++)
                i == _currentPage
                    ? _buildPageIndicator(true, i) // Current page
                    : _buildPageIndicator(false, i),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPageIndicator(bool isActive, int pageIndex) {
    double buttonWidth = 8;
    double buttonRadius = buttonWidth / 2;

    return GestureDetector(
      onTap: () {
        // Move the page view to the tapped page
        _pageController.animateToPage(
          pageIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        height: buttonWidth,
        width: isActive ? buttonWidth : buttonWidth,
        decoration: BoxDecoration(
          color: isActive ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      ),
    );
  }

  Widget _buildRecommendationTile(Recommendation recommendation) {
    double imageRadius = 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: imageRadius,
                backgroundImage: NetworkImage(recommendation.imageURL ?? ''),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                        maxWidth: 500,
                      ),
                      child: Text(
                        '"${recommendation.description}"',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Text(
                      recommendation.colleagueName ?? 'Colleague Name',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      recommendation.colleagueJobTitle ?? 'Job Title',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 600,
          child: Divider(
            height: 1.0, // Height of the divider line
            color: Colors.black, // Color of the divider line
          ),
        ),
      ],
    );
  }
}
