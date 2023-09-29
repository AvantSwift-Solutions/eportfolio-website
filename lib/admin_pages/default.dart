import 'dart:developer';
import 'package:avantswift_portfolio/admin_pages/award_cert_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/education_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/landing_page_admin.dart';
import 'package:avantswift_portfolio/admin_pages/about_me_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/contact_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/project_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/experience_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/recommendation_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/tskill_section_admin.dart';
import 'package:avantswift_portfolio/admin_pages/iskill_section_admin.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class DefaultPage extends StatelessWidget {
  final User user;

  const DefaultPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints bc) {
      double welcomeFontSize = 60, titleFontSize = 48, subtitleFontSize = 18;
      if (bc.maxWidth < 1200) {
        welcomeFontSize = 60;
        titleFontSize = 48;
        subtitleFontSize = 36;
      }

      log('maxHeight: ${bc.maxHeight}, maxWidth: ${bc.maxWidth}, minHeight: ${bc.minHeight}, minWidth: ${bc.minWidth}');
      return Scaffold(
        body: SizedBox(
            height: bc.maxHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: bc.maxWidth * 0.03,
                            vertical: bc.maxHeight * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Logout'),
                                ),
                                SizedBox(width: bc.maxWidth * 0.02),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Help'),
                                ),
                                SizedBox(width: bc.maxWidth * 0.02),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('About ASS'),
                                ),
                              ],
                            ),
                            SizedBox(height: bc.maxHeight * 0.07),
                            Text(
                              'Welcome to your ePortfolio Admin Panel, ${user.nickname}',
                              style: PublicViewTextStyles.generalHeading
                                  .copyWith(fontSize: welcomeFontSize),
                            ),
                            SizedBox(height: bc.maxHeight * 0.02),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Powered by',
                                    style: PublicViewTextStyles.generalHeading
                                        .copyWith(
                                      fontSize: subtitleFontSize,
                                    ),
                                  ),
                                ),
                                SizedBox(width: bc.maxWidth * 0.01),
                                Image.asset(
                                  'assets/logo-no-background.png',
                                  scale: 8,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                          color: Colors.grey[200],
                          child: StaggeredGrid.count(
                            crossAxisCount: 5,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                            children: const [
                              StaggeredGridTile.count(
                                crossAxisCellCount: 4,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: LandingPageAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 2,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: AboutMeSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 2,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ExperienceSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: EducationSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 1,
                                mainAxisCellCount: 2,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: AwardCertSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: TSkillSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: RecommendationSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ISkillSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 2,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ProjectSectionAdmin()),
                              ),
                              StaggeredGridTile.count(
                                crossAxisCellCount: 3,
                                mainAxisCellCount: 1,
                                child: Padding(
                                    padding: EdgeInsets.all(4),
                                    child: ContactSectionAdmin()),
                              ),
                            ],
                          ))),
                ])),
      );
    });
  }
}
