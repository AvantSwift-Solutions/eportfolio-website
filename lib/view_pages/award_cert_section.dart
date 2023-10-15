import 'dart:developer';

import 'package:avantswift_portfolio/controllers/view_controllers/award_cert_section_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/reposervice/award_cert_repo_services.dart';
import 'package:avantswift_portfolio/view_pages/recommendation_section.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';

class AwardCertSection extends StatefulWidget {
  final AwardCertSectionController? controller;
  const AwardCertSection({Key? key, this.controller}) : super(key: key);

  @override
  AwardCertSectionState createState() => AwardCertSectionState();
}

class AwardCertSectionState extends State<AwardCertSection> {
  late AwardCertSectionController _awardCertSectionController;
  List<AwardCert>? awardCerts;
  final PageController _pageController =
      PageController(viewportFraction: 1.0, initialPage: 0);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _awardCertSectionController =
        widget.controller ?? AwardCertSectionController(AwardCertRepoService());
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
          await _awardCertSectionController.getAwardCertList();
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
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 600;

    int awardsPerRow = isMobileView ? 2 : 3;
    int totalPages = (awardCerts?.length ?? 0) ~/ (awardsPerRow * 2) + 1;
    double awardCertSectionHeight =
        isMobileView ? screenWidth * 0.9 : screenWidth * 0.35;
    double titleFontSize =
        isMobileView ? screenWidth * 0.07 : screenWidth * 0.03;
    double gapWidth = isMobileView ? screenWidth * 0.05 : screenWidth * 0.1;
    double titlePadding =
        isMobileView ? screenWidth * 0.06 : screenWidth * 0.05;
    double generalPadding =
        isMobileView ? screenWidth * 0.05 : screenWidth * 0.1;

    if (!isMobileView) {
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
                  padding: EdgeInsets.only(left: titlePadding),
                  child: Text(
                    'Awards & Certifications',
                    style: PublicViewTextStyles.generalHeading.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: titleFontSize,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (awardCerts != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: SizedBox(
                      height: awardCertSectionHeight,
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
                            padding: const EdgeInsets.all(10),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                  ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: totalPages > 1 ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < totalPages; i++)
                        i == _currentPage
                            ? _buildPageIndicator(true, i)
                            : _buildPageIndicator(false, i),
                    ],
                  ) : SizedBox(),
                ),
              ],
            ),
          ),
          SizedBox(width: gapWidth),
          // Right Section (Peer Recommendations or other content)
          const Expanded(
            flex: 1,
            child: RecommendationSection(),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: generalPadding),
            child: Text(
              'Awards & Certifications',
              style: PublicViewTextStyles.generalHeading.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: titleFontSize,
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (awardCerts != null)
            SizedBox(
              height: awardCertSectionHeight,
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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
          if (awardCerts == null)
            Text(
              'Error loading awards and certificates.',
              style: PublicViewTextStyles.generalBodyText,
            ),
          Padding(
            padding: EdgeInsets.only(bottom: generalPadding),
            child: totalPages > 1 ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < totalPages; i++)
                  i == _currentPage
                      ? _buildPageIndicator(true, i)
                      : _buildPageIndicator(false, i),
              ],
            ) : SizedBox(),
          ),
          SizedBox(height: gapWidth),
          const RecommendationSection(),
        ],
      );
    }
  }

  Widget _buildAwardCertCircle(AwardCert awardCert) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool isMobileView = screenWidth <= 600;

    double awardCertCircleSize =
        isMobileView ? screenWidth * 0.15 : screenWidth * 0.05;
    double awardCertsSourceFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.01;

    double awardCertsNameFontSize =
        isMobileView ? screenWidth * 0.03 : screenWidth * 0.01;

    return Column(
      children: [
        InkWell(
          onTap: () => openLink(awardCert.link ?? ''),
          child: CircleAvatar(
            backgroundColor: const Color(0xffD9EACB),
            radius: awardCertCircleSize,
            backgroundImage: awardCert.imageURL != null
                ? NetworkImage(awardCert.imageURL!)
                : null,
            child: awardCert.imageURL == null
                ? Center(
                    child: Text(
                      awardCert.source ?? 'Source',
                      style: TextStyle(
                        fontSize: awardCertsSourceFontSize,
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
          style: TextStyle(
            fontSize: awardCertsNameFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
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
          color: isActive ? Colors.black : Colors.grey,
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
      ),
    );
  }
}
