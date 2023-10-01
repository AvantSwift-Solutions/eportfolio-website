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
import 'package:url_launcher/url_launcher_string.dart';

class DefaultPage extends StatelessWidget {
  static Color greyBg = const Color.fromRGBO(238, 238, 238, 1);
  static const List<Color> palette = [
    Color(0xFF0074D9),
    Color(0xFF1F2041),
    Color.fromRGBO(96, 125, 139, 1),
    Color.fromRGBO(48, 63, 159, 1),
    Color.fromRGBO(3, 169, 244, 1),
  ];
  static ButtonStyle analyticStyle = ButtonStyle(

    // foregroundColor controls the text color
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
    ),
  );

  static const double maxAnalyticSize = 100;
  static const double valueAnalyticRatio = 3;
  static const double iconAnalyticRatio = 3;
  static const double interAnalyticIconSpacingRatio = 2;

  static const double analyticsGridSpacing = 15;
  static const double editorGridSpacing = 10;

  final User user;

  const DefaultPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints bc) {
      double verticalPaddingMultiplier = 0.05;
      EdgeInsets halfPadding = EdgeInsets.symmetric(
          horizontal: bc.maxWidth * 0.03,
          vertical: bc.maxHeight * verticalPaddingMultiplier);
      double maxWelcomeFontSize = 60, titleFontSize = 42, subtitleFontSize = 22, navbarFontSize = 23;
      TextStyle navbarTextStyle = TextStyle(fontSize: navbarFontSize);
      SizedBox navbarInterItemSpacing = SizedBox(width: bc.maxWidth * 0.02);
      double navbarBottomSpacingMultiplier = 0.06;
      SizedBox navbarBottomSpacing =
          SizedBox(height: bc.maxHeight * navbarBottomSpacingMultiplier);
      SizedBox interWelcomePoweredSpacing =
          SizedBox(height: bc.maxHeight * 0.01);
      double logoScale = 8; // Larger number -> smaller logo
      SizedBox interPowerViewSpacing = SizedBox(height: bc.maxHeight * 0.06);
      double viewbuttonHeight = bc.maxHeight * 0.08;
      SizedBox interViewAnalyticsSpacing =
          SizedBox(height: bc.maxHeight * 0.04);
      SizedBox interAnalysticCardsSpacing =
          SizedBox(height: bc.maxHeight * 0.02);
      int analyticCardRowCount = 3;
      double analyticCardAspectRatio = 1.4;

      SizedBox aboveEditorSpacing = SizedBox(
          height: bc.maxHeight * (navbarBottomSpacingMultiplier + 0.01) +
              subtitleFontSize);
      double interEditorButtonsSpacingMultiplier = 0.05;
      SizedBox interEditorButtonsSpacing =
          SizedBox(height: bc.maxHeight * interEditorButtonsSpacingMultiplier);
      // Since the size of the StaggeredGrid is controlled by width and its
      // square, make sure the height doesn't overflow.
      // Make sure height is less than the height of the screen minus everything
      // above it and also add 0.07 for padding.
      double editorButtonsWidth = bc.maxHeight -
          (bc.maxHeight *
                  (verticalPaddingMultiplier * 2 +
                      (navbarBottomSpacingMultiplier + 0.01) +
                      interEditorButtonsSpacingMultiplier +
                      0.07) +
              2 * subtitleFontSize +
              navbarFontSize +
              titleFontSize);
      
      if (bc.maxWidth < 1200) {
        // maxWelcomeFontSize = 55;
        // titleFontSize = 48;
        // subtitleFontSize = 22;
      }

      return Scaffold(
        body: SizedBox(
            height: bc.maxHeight,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Padding(
                    padding: halfPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text('Logout', style: navbarTextStyle),
                            ),
                            navbarInterItemSpacing,
                            TextButton(
                              onPressed: () {},
                              child: Text('Help', style: navbarTextStyle),
                            ),
                            navbarInterItemSpacing,
                            TextButton(
                              onPressed: () {},
                              child: Text('About ASS', style: navbarTextStyle),
                            ),
                          ],
                        ),
                        navbarBottomSpacing,
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Welcome to your ePortfolio\nAdmin Panel, ${user.nickname}',
                            style: PublicViewTextStyles.generalHeading
                                .copyWith(fontSize: maxWelcomeFontSize),
                          ),
                        ),
                        interWelcomePoweredSpacing,
                        Row(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Powered by  ',
                                style: PublicViewTextStyles.generalBodyText
                                    .copyWith(
                                  fontSize: subtitleFontSize,
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/logo-no-background.png',
                              scale: logoScale,
                            ),
                          ],
                        ),
                        interPowerViewSpacing,
                        SizedBox(
                          height: viewbuttonHeight,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                launchUrlString('/');
                              },
                              style: analyticStyle.copyWith(
                                backgroundColor: MaterialStateProperty.all<Color>(palette[0]),
                              ),
                              child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    children: [
                                      Text('View your ePortfolio   ',
                                          style: TextStyle(
                                              fontSize: titleFontSize)),
                                      Icon(
                                        Icons.launch,
                                        size: titleFontSize,
                                      ),
                                    ],
                                  ))),
                        ),
                        interViewAnalyticsSpacing,
                        Text(
                          '––– Site Analytics',
                          style: PublicViewTextStyles.generalHeading
                              .copyWith(fontSize: titleFontSize),
                        ),
                        Text(
                          'See how well your ePortfolio is doing.',
                          style: PublicViewTextStyles.generalBodyText
                              .copyWith(fontSize: subtitleFontSize),
                        ),
                        interAnalysticCardsSpacing,
                        Expanded(
                            child: CustomScrollView(
                          primary: false,
                          slivers: <Widget>[
                            SliverGrid.count(
                              crossAxisSpacing: analyticsGridSpacing,
                              mainAxisSpacing: analyticsGridSpacing,
                              crossAxisCount: analyticCardRowCount,
                              childAspectRatio: analyticCardAspectRatio,
                              children: <Widget>[
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Views'),
                                              ));
                                    },
                                    style: analyticStyle.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color>(palette[1]),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('8',
                                                  style: TextStyle(
                                                      fontSize:
                                                          valueAnalyticRatio *
                                                              maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'ePortfolio views in the past week',
                                                  style: TextStyle(
                                                      fontSize: maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                  height:
                                                      interAnalyticIconSpacingRatio *
                                                          maxAnalyticSize),
                                            ],
                                          ),
                                          Icon(
                                            Icons.visibility,
                                            size: iconAnalyticRatio *
                                                maxAnalyticSize,
                                          ),
                                        ],
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Views'),
                                              ));
                                    },
                                    style: analyticStyle.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color>(palette[2]),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('3',
                                                  style: TextStyle(
                                                      fontSize:
                                                          valueAnalyticRatio *
                                                              maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'New messages in the past month',
                                                  style: TextStyle(
                                                      fontSize: maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                  height:
                                                      interAnalyticIconSpacingRatio *
                                                          maxAnalyticSize),
                                            ],
                                          ),
                                          Icon(
                                            Icons.chat,
                                            size: iconAnalyticRatio *
                                                maxAnalyticSize,
                                          ),
                                        ],
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Views'),
                                              ));
                                    },
                                    style: analyticStyle.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color>(palette[3]),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('16',
                                                  style: TextStyle(
                                                      fontSize:
                                                          valueAnalyticRatio *
                                                              maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'Days since ePortfolio was edited',
                                                  style: TextStyle(
                                                      fontSize: maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                  height:
                                                      interAnalyticIconSpacingRatio *
                                                          maxAnalyticSize),
                                            ],
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: iconAnalyticRatio *
                                                maxAnalyticSize,
                                          ),
                                        ],
                                      ),
                                    )),
                                ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Views'),
                                              ));
                                    },
                                    style: analyticStyle.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color>(palette[4]),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('16',
                                                  style: TextStyle(
                                                      fontSize:
                                                          valueAnalyticRatio *
                                                              maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'Days since ePortfolio was edited',
                                                  style: TextStyle(
                                                      fontSize: maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                  height:
                                                      interAnalyticIconSpacingRatio *
                                                          maxAnalyticSize),
                                            ],
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: iconAnalyticRatio *
                                                maxAnalyticSize,
                                          ),
                                        ],
                                      ),
                                    )),
                                    ElevatedButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              const AlertDialog(
                                                title: Text('Views'),
                                              ));
                                    },
                                    style: analyticStyle.copyWith(
                                      backgroundColor: MaterialStateProperty.all<Color>(palette[1]),
                                    ),
                                    child: const FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('16',
                                                  style: TextStyle(
                                                      fontSize:
                                                          valueAnalyticRatio *
                                                              maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              Text(
                                                  'Days since ePortfolio was edited',
                                                  style: TextStyle(
                                                      fontSize: maxAnalyticSize,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                  height:
                                                      interAnalyticIconSpacingRatio *
                                                          maxAnalyticSize),
                                            ],
                                          ),
                                          Icon(
                                            Icons.edit,
                                            size: iconAnalyticRatio *
                                                maxAnalyticSize,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  )),
                  Expanded(
                      child: Container(
                          padding: halfPadding,
                          color: greyBg,
                          child: Column(
                            children: [
                              aboveEditorSpacing,
                              Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '––– Editor',
                                        style: PublicViewTextStyles
                                            .generalHeading
                                            .copyWith(fontSize: titleFontSize),
                                      ),
                                      Text(
                                        'Start editing your ePortfolio by clicking on a section below.',
                                        style: PublicViewTextStyles
                                            .generalBodyText
                                            .copyWith(
                                                fontSize: subtitleFontSize),
                                      ),
                                    ],
                                  )),
                              interEditorButtonsSpacing,
                              SizedBox(
                                width: editorButtonsWidth,
                                child: StaggeredGrid.count(
                                  crossAxisCount: 5,
                                  mainAxisSpacing: editorGridSpacing,
                                  crossAxisSpacing: editorGridSpacing,
                                  children: const [
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 4,
                                      mainAxisCellCount: 1,
                                      child: LandingPageAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount: 2,
                                      child: AboutMeSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 2,
                                      child: ExperienceSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: EducationSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 1,
                                      mainAxisCellCount: 2,
                                      child: AwardCertSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: TSkillSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: RecommendationSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: ISkillSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 2,
                                      mainAxisCellCount: 1,
                                      child: ProjectSectionAdmin(),
                                    ),
                                    StaggeredGridTile.count(
                                      crossAxisCellCount: 3,
                                      mainAxisCellCount: 1,
                                      child: ContactSectionAdmin(),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))),
                ])),
      );
    });
  }
}
