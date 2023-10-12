import 'dart:math';

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
import 'package:avantswift_portfolio/controllers/analytic_controller.dart';
import 'package:avantswift_portfolio/models/Analytic.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/reposervice/analytic_repo_services.dart';
import 'package:avantswift_portfolio/ui/admin_view_dialog_styles.dart';
import 'package:avantswift_portfolio/ui/custom_texts/public_view_text_styles.dart';
import 'package:avantswift_portfolio/admin_pages/about_ass.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher_string.dart';


class DefaultPage extends StatefulWidget {
  final User user;
  const DefaultPage({super.key, required this.user});

  @override
  DefaultPageState createState() => DefaultPageState();
}

class DefaultPageState extends State<DefaultPage> {
  late User user;
  late int views = 0;
  late int messages = 0;
  static int daysSinceLastEdit = 0;
  static void setEdit() {
    daysSinceLastEdit = 0;
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    user = widget.user;

    await AnalyticController.checkReset(AnalyticRepoService());

    Analytic analytics = await AnalyticRepoService().getAnalytic() ??
        Analytic(
            analyticId: '',
            month: Timestamp.now(),
            messages: 0,
            views: 0,
            lastEdit: Timestamp.now());

    views = analytics.views ?? 0;
    messages = analytics.messages ?? 0;
    Timestamp lastEdit = analytics.lastEdit ?? Timestamp.now();
    daysSinceLastEdit = DateTime.now().difference(lastEdit.toDate()).inDays;

    setState(() {});
  }

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

  static const double mobileWidthThreshold = 1200;
  static const double mobileHeightThreshold = 600;

  static const double maxAnalyticSize = 100;
  static const double valueAnalyticRatio = 3;
  static const double iconAnalyticRatio = 3;

  static const double analyticsGridSpacing = 15;
  static const double editorGridSpacing = 10;

  static const double avantSwiftSolutionsLogoWidth = 90;
  static const double avantSwiftSolutionsLogoHeight = 90;
  static const double forgotPasswordPadding = 20.0;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints bc) {
      // print("width: ${bc.maxWidth}, height: ${bc.maxHeight}");
      double verticalPaddingMultiplier = 0.05;
      EdgeInsets halfPadding = EdgeInsets.symmetric(
          horizontal: bc.maxWidth * 0.03,
          vertical: bc.maxHeight * verticalPaddingMultiplier);
      EdgeInsets mobilePadding = EdgeInsets.only(
          left: bc.maxWidth * 0.04, right: bc.maxWidth * 0.04, top: 30);
      String welcomeMessage =
          'Welcome to your ePortfolio\nAdmin Panel, ${user.nickname}';
      double maxWelcomeFontSize = 60,
          titleFontSize = 42,
          subtitleFontSize = 22,
          navbarFontSize = 23;
      TextStyle navbarTextStyle = TextStyle(fontSize: navbarFontSize);
      SizedBox navbarInterItemSpacing = SizedBox(width: bc.maxWidth * 0.02);
      double navbarBottomSpacingMultiplier = 0.06;
      SizedBox navbarBottomSpacing =
          SizedBox(height: bc.maxHeight * navbarBottomSpacingMultiplier);
      SizedBox interWelcomePoweredSpacing =
          SizedBox(height: bc.maxHeight * 0.01);
      // double logoScale = 8; // Larger number -> smaller logo
      SizedBox interPowerViewSpacing = SizedBox(height: bc.maxHeight * 0.06);
      double viewbuttonHeight = bc.maxHeight * 0.08;
      SizedBox interViewAnalyticsSpacing =
          SizedBox(height: bc.maxHeight * 0.04);
      SizedBox interAnalysticCardsSpacing =
          SizedBox(height: bc.maxHeight * 0.02);
      int analyticCardRowCount = 3;
      double analyticCardAspectRatio = 1.4;
      double analyticsHeightPerRow = bc.maxWidth * 0.25;
      double interAnalyticIconSpacingRatio = 2;
      double analyticBotPaddingRatio = 0.5;

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

      if (bc.maxWidth > mobileWidthThreshold &&
          bc.maxHeight > mobileHeightThreshold) {
        AdminViewDialogStyles.increaseEditSectionButtonPadding();
      } else {
        editorButtonsWidth = min(800, bc.maxWidth);
        interEditorButtonsSpacing = SizedBox(height: bc.maxHeight * 0.03);
        interAnalysticCardsSpacing = interEditorButtonsSpacing;
        AdminViewDialogStyles.reduceEditSectionButtonPadding();
        interAnalyticIconSpacingRatio = 1;
      }
      if (bc.maxWidth < 800) {
        welcomeMessage =
            'Welcome to your\nePortfolio Admin\nPanel, ${user.nickname}';
        analyticCardRowCount = 2;
        analyticsHeightPerRow = bc.maxWidth * 0.5;
      }

      Widget navbarWidget = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () {},
            child: Text('Logout', style: navbarTextStyle),
          ),
          navbarInterItemSpacing,
          TextButton(
            onPressed: () {
              showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return Theme(
              data: AdminViewDialogStyles.dialogThemeData,
              child: AlertDialog(
                  titlePadding: AdminViewDialogStyles.titleDialogPadding,
                  contentPadding: AdminViewDialogStyles.contentDialogPadding,
                  actionsPadding: AdminViewDialogStyles.actionsDialogPadding,
                  title: Container(
                      padding: AdminViewDialogStyles.titleContPadding,
                      color: AdminViewDialogStyles.bgColor,
                      child: Column(
                        children: [
                          FittedBox(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Contact Us                        '),
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.close),
                                  iconSize: AdminViewDialogStyles.closeIconSize,
                                  hoverColor: Colors.transparent,
                                  onPressed: () {
                                    Navigator.of(dialogContext).pop();
                                  },
                                ),
                              ),
                            ],
                          )),
                          const Divider()
                        ],
                      )),
                  content: const SizedBox(
                    width:
                        1, // Width is set to 1 to make it fit the title not the content
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                            'Please direct any queries or concerns to avantswiftsolutions@gmail.com'),
                        SizedBox(height: forgotPasswordPadding),
                      ],
                    ),
                  )),
            );
          },
        );
            },
            child: Text('Contact Us', style: navbarTextStyle),
          ),
        ],
      );

      Widget welcomeWidget = FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          welcomeMessage,
          style: PublicViewTextStyles.generalHeading
              .copyWith(fontSize: maxWelcomeFontSize),
        ),
      );

      Widget poweredWidget = Row(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Powered by  ',
              style: PublicViewTextStyles.generalBodyText.copyWith(
                fontSize: subtitleFontSize,
              ),
            ),
          ),
          GestureDetector(
            child: Image.asset(
              'assets/logo-no-background.png',
              width: avantSwiftSolutionsLogoWidth, // Adjust the width as needed
              height: avantSwiftSolutionsLogoWidth, // Adjust the height as needed
            ),
            onTap: () {
              showDialog(
                context: context, 
                builder: (BuildContext context) {
                  return const AboutAssDialog();
                } 
              );
            },
          ),
        ],
      );

      Widget viewButtonWidget = SizedBox(
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
                        style: TextStyle(fontSize: titleFontSize)),
                    Icon(
                      Icons.launch,
                      size: titleFontSize,
                    ),
                  ],
                ))),
      );

      Widget analyticsTitleWidget = Text(
        '––– Site Analytics',
        style: PublicViewTextStyles.generalHeading
            .copyWith(fontSize: titleFontSize),
      );

      Widget analyticsSubtitleWidget = Text(
        'See how well your ePortfolio is doing.',
        style: PublicViewTextStyles.generalBodyText
            .copyWith(fontSize: subtitleFontSize),
      );

      List<Widget> analyticsWidgetList = [
        ElevatedButton(
            onPressed: () {},
            style: analyticStyle.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(palette[1]),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(views.toString(),
                          style: const TextStyle(
                              fontSize: valueAnalyticRatio * maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      Text(
                          (bc.maxWidth > mobileWidthThreshold &&
                                  bc.maxHeight > mobileHeightThreshold)
                              ? 'ePortfolio views last week'
                              : 'Views last week',
                          style: const TextStyle(
                              fontSize: maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:
                              interAnalyticIconSpacingRatio * maxAnalyticSize),
                    ],
                  ),
                  const Icon(
                    Icons.visibility,
                    size: iconAnalyticRatio * maxAnalyticSize,
                  ),
                  SizedBox(height: analyticBotPaddingRatio * maxAnalyticSize),
                ],
              ),
            )),
        ElevatedButton(
            onPressed: () {},
            style: analyticStyle.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(palette[2]),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(messages.toString(),
                          style: const TextStyle(
                              fontSize: valueAnalyticRatio * maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      Text(
                          (bc.maxWidth > mobileWidthThreshold &&
                                  bc.maxHeight > mobileHeightThreshold)
                              ? 'Messages in the last month'
                              : 'Messages last month',
                          style: const TextStyle(
                              fontSize: maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:
                              interAnalyticIconSpacingRatio * maxAnalyticSize),
                    ],
                  ),
                  const Icon(
                    Icons.chat,
                    size: iconAnalyticRatio * maxAnalyticSize,
                  ),
                  SizedBox(height: analyticBotPaddingRatio * maxAnalyticSize),
                ],
              ),
            )),
        ElevatedButton(
            onPressed: () {},
            style: analyticStyle.copyWith(
              backgroundColor: MaterialStateProperty.all<Color>(palette[3]),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(daysSinceLastEdit.toString(),
                          style: const TextStyle(
                              fontSize: valueAnalyticRatio * maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      Text(
                          (bc.maxWidth > mobileWidthThreshold &&
                                  bc.maxHeight > mobileHeightThreshold)
                              ? 'Days since last ePortfolio edit'
                              : 'Days since last edit',
                          style: const TextStyle(
                              fontSize: maxAnalyticSize,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                          height:
                              interAnalyticIconSpacingRatio * maxAnalyticSize),
                    ],
                  ),
                  const Icon(
                    Icons.edit,
                    size: iconAnalyticRatio * maxAnalyticSize,
                  ),
                  SizedBox(height: analyticBotPaddingRatio * maxAnalyticSize),
                ],
              ),
            )),
      ];

      Widget analyticsGridWidget = SizedBox(
          height: analyticsWidgetList.length /
              analyticCardRowCount *
              analyticsHeightPerRow,
          child: CustomScrollView(
            primary: true,
            slivers: <Widget>[
              SliverGrid.count(
                crossAxisSpacing: analyticsGridSpacing,
                mainAxisSpacing: analyticsGridSpacing,
                crossAxisCount: analyticCardRowCount,
                childAspectRatio: analyticCardAspectRatio,
                children: analyticsWidgetList,
              ),
            ],
          ));

      Widget editorTitleWidget = Text(
        '––– Editor',
        style: PublicViewTextStyles.generalHeading
            .copyWith(fontSize: titleFontSize),
      );

      Widget editorSubtitleWidget = SizedBox(
          width: editorButtonsWidth,
          child: Text(
            'Start editing your ePortfolio by clicking on a section below.',
            style: PublicViewTextStyles.generalBodyText
                .copyWith(fontSize: subtitleFontSize),
          ));

      Widget editorGridWidget = SizedBox(
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
      );

      if (bc.maxWidth > mobileWidthThreshold &&
          bc.maxHeight > mobileHeightThreshold) {
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
                          navbarWidget,
                          navbarBottomSpacing,
                          welcomeWidget,
                          interWelcomePoweredSpacing,
                          poweredWidget,
                          interPowerViewSpacing,
                          viewButtonWidget,
                          interViewAnalyticsSpacing,
                          analyticsTitleWidget,
                          analyticsSubtitleWidget,
                          interAnalysticCardsSpacing,
                          Expanded(child: analyticsGridWidget)
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
                                        editorTitleWidget,
                                        editorSubtitleWidget,
                                        interEditorButtonsSpacing,
                                        editorGridWidget,
                                      ],
                                    )),
                              ],
                            ))),
                  ])),
        );
      } else {
        return Scaffold(
          body: SingleChildScrollView(
              child: Padding(
            padding: mobilePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(child: navbarWidget),
                navbarBottomSpacing,
                welcomeWidget,
                interWelcomePoweredSpacing,
                FittedBox(child: poweredWidget),
                interPowerViewSpacing,
                viewButtonWidget,
                interPowerViewSpacing,
                editorTitleWidget,
                editorSubtitleWidget,
                interEditorButtonsSpacing,
                Align(
                  alignment: Alignment.center,
                  child: editorGridWidget,
                ),
                interPowerViewSpacing,
                analyticsTitleWidget,
                analyticsSubtitleWidget,
                interAnalysticCardsSpacing,
                analyticsGridWidget,
              ],
            ),
          )),
        );
      }
    });
  }
}
