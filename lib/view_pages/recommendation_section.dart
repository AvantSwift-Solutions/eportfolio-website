import 'package:avantswift_portfolio/models/Recommendation.dart';
import 'package:avantswift_portfolio/reposervice/recommendation_repo_services.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecommendationSection extends StatefulWidget {
  const RecommendationSection({Key? key}) : super(key: key);

  @override
  RecommendationSectionState createState() => RecommendationSectionState();
}

class RecommendationSectionState extends State<RecommendationSection> {
  final RecommendationRepoService _recommendationRepoService = RecommendationRepoService();
  List<Recommendation>? recommendations;
  PageController _pageController = PageController(viewportFraction: 1.0, initialPage: 0);
  static const int recommendationsPerPage = 3;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
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
          await _recommendationRepoService.getAllRecommendations();
      setState(() {
        recommendations = fetchedRecommendations;
      });
    } catch (e) {
      print('Error fetching awards and certificates: $e');
      // Handle the error, e.g., show an error message to the user.
    }
  }

  void openLink(String link) async {
    if (await canLaunchUrlString(link)) {
      await launchUrlString(link);
    } else {
      print('Could not launch $link');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalPages = (recommendations?.length ?? 0) ~/ recommendationsPerPage + 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
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
          padding: EdgeInsets.only(left: 20.0),
          width: 625,
          child: Divider(
            height: 1.0, // Height of the divider line
            color: Colors.black, // Color of the divider line
          ),
        ),
        SizedBox(
          height: 700,
          child: PageView.builder(
            controller: _pageController,
            itemCount: totalPages,
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, pageIndex) {
              int startIndex = pageIndex * recommendationsPerPage;
              int endIndex = (pageIndex + 1) * recommendationsPerPage;
              endIndex = endIndex < (recommendations?.length ?? 0) ? endIndex : (recommendations?.length ?? 0);

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
                            .map((recommendation) => _buildRecommendationTile(recommendation))
                            .toList(),
                      ),
                    ),
                  if (recommendations == null)
                    Text(
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
  return GestureDetector(
    onTap: () {
      // Move the page view to the tapped page
      _pageController.animateToPage(
        pageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    },
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 8.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.blue : Colors.grey,
        borderRadius: BorderRadius.circular(4.0),
      ),
    ),
  );
}
Widget _buildRecommendationTile(Recommendation recommendation) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ListTile(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(recommendation.imageURL ?? ''),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: 500,
                    ),
                    child: Text(
                      '"${recommendation.description}"',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    recommendation.colleagueName ?? 'Colleague Name',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    recommendation.colleagueJobTitle ?? 'Job Title',
                    style: TextStyle(
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
      Container(
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