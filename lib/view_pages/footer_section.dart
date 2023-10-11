import 'package:avantswift_portfolio/dto/section_keys_dto.dart';
import 'package:flutter/material.dart';
import 'package:avantswift_portfolio/admin_pages/about_ass.dart';
import '../ui/custom_texts/public_view_text_styles.dart';

class FooterSection extends StatelessWidget {
  static const double dividerThickness = 1.0;
  static const double verticalPadding = 20;
  static const double formGapSize = 10.0;
  static const double bodyTextSize = 15.0;
  static const double avantSwiftSolutionsLogoWidth = 90;
  static const double avantSwiftSolutionsLogoHeight = 90;
  final Function(GlobalKey) scrollToSection;
  final SectionKeysDTO sectionKeys;

  const FooterSection({
    Key? key,
    required this.scrollToSection,
    required this.sectionKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          // For screens less than 600 pixels wide, stack the elements vertically
          return Column(
            children: <Widget>[
              const Divider(
                color: Color(0xFFBABAB3),
                thickness: dividerThickness,
              ),
              Container(
                color: const Color(0xFFFDFCFF),
                padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                child: Column(
                  children: [
                    PublicViewTextStyles.styledLogo(),
                    const SizedBox(height: formGapSize),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Powered by',
                          style: PublicViewTextStyles.generalHeading.copyWith(
                            fontSize: bodyTextSize * 1.5,
                          ),
                        ),
                        const SizedBox(width: formGapSize),
                        GestureDetector(
                          child: Image.asset(
                            'assets/logo-no-background.png',
                            width: avantSwiftSolutionsLogoWidth * 1.5,
                            height: avantSwiftSolutionsLogoHeight,
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return const AboutAssDialog();
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          // For wider screens, keep the existing layout
          return Column(
            children: <Widget>[
              const Divider(
                color: Color(0xFFBABAB3),
                thickness: dividerThickness,
              ),
              Container(
                color: const Color(0xFFFDFCFF),
                padding: const EdgeInsets.symmetric(vertical: verticalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: PublicViewTextStyles.styledLogo(),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Powered by',
                                style: PublicViewTextStyles.generalHeading.copyWith(
                                  fontSize: bodyTextSize * 1.5,
                                ),
                              ),
                              const SizedBox(width: formGapSize),
                              GestureDetector(
                                child: Image.asset(
                                  'assets/logo-no-background.png',
                                  width: avantSwiftSolutionsLogoWidth * 1.5,
                                  height: avantSwiftSolutionsLogoHeight,
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const AboutAssDialog();
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
