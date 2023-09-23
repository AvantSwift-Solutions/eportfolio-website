import 'dart:developer';

import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:avantswift_portfolio/view_pages/recommendation_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';

class AwardCertSection extends StatefulWidget {
  const AwardCertSection({Key? key}) : super(key: key);

  @override
  AwardCertSectionState createState() => AwardCertSectionState();
}

class AwardCertSectionState extends State<AwardCertSection> {
  final AwardCertRepoService _awardCertRepoService = AwardCertRepoService();
  List<AwardCert>? awardCerts;
  final PageController _pageController =
      PageController(viewportFraction: 1.0, initialPage: 0);
  static const int awardsPerRow = 3;
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
      final List<AwardCert>? fetchedAwardCerts =
          await _awardCertRepoService.getAllAwardCert();
      setState(() {
        awardCerts = fetchedAwardCerts;
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
    int totalPages = (awardCerts?.length ?? 0) ~/ (awardsPerRow * 2) + 1;
    final screenWidth = MediaQuery.of(context).size.width;
    double titleFontSize = screenWidth * 0.03;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Section (Awards and Certificates)
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 80.0),
                child: Text(
                  'Awards & Certifications',
                  style: PublicViewTextStyles.generalHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                  ),
                  // style: TextStyle(
                  //   fontSize: 64,
                  //   fontWeight: FontWeight.bold,
                  //   fontFamily: 'Montserrat',
                  // ),
                ),
              ),
              const SizedBox(height: 40),
              if (awardCerts != null)
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: SizedBox(
                    height: 450,
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: totalPages,
                      itemBuilder: (context, pageIndex) {
                        int startIndex = pageIndex * (awardsPerRow * 2);
                        int endIndex = (pageIndex + 1) * (awardsPerRow * 2);
                        endIndex = endIndex < awardCerts!.length
                            ? endIndex
                            : awardCerts!.length;

                        return GridView.builder(
                          padding: const EdgeInsets.all(20),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: awardsPerRow,
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: endIndex - startIndex,
                          itemBuilder: (context, index) {
                            return _buildAwardCertCircle(
                                awardCerts![startIndex + index]);
                          },
                        );
                      },
                    ),
                  ),
                ),
              if (awardCerts == null)
                Text(
                  'Error loading awards and certificates.',
                  style: PublicViewTextStyles.generalBodyText,
                  // style: TextStyle(
                  //   fontSize: 16,
                  //   color: Colors.red,
                  // ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < totalPages; i++)
                      i == _currentPage
                          ? _buildPageIndicator(true, i)
                          : _buildPageIndicator(false, i),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 200),
        // Right Section (Peer Recommendations or other content)
        const Expanded(
          flex: 1,
          child: RecommendationSection(),
        ),
      ],
    );
  }

  Widget _buildAwardCertCircle(AwardCert awardCert) {
    return Column(
      children: [
        InkWell(
          onTap: () => openLink(awardCert.link ?? ''),
          child: CircleAvatar(
            backgroundColor: const Color(0xffD9EACB),
            radius: 80.0,
            backgroundImage: awardCert.imageURL != null
                ? NetworkImage(awardCert.imageURL!)
                : null,
            child: awardCert.imageURL == null
                ? Center(
                    child: Text(
                      awardCert.source ?? 'Source',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 10.0),
        Text(
          awardCert.name ?? 'Certificate Name',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        // SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildPageIndicator(bool isActive, int pageIndex) {
    double buttonWidth = 8.0;
    double buttonRadius = buttonWidth / 2;

    return GestureDetector(
      onTap: () {
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
}
