import 'package:avantswift_portfolio/controllers/view_controllers/award_cert_section_controller.dart';
import 'package:avantswift_portfolio/models/AwardCert.dart';
import 'package:avantswift_portfolio/view_pages/award_cert_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';

import 'mocks/award_cert_section_test.mocks.dart';
import 'view_pages_test_constants.dart';

@GenerateMocks([AwardCert, AwardCertSectionController])
void main() {
  group('Awards & Certification Section Widget Test', () {
    late MockAwardCert ac1;
    late MockAwardCert ac2;
    late MockAwardCertSectionController mockController;

    setUp(() {
      ac1 = MockAwardCert();
      ac2 = MockAwardCert();

      when(ac1.creationTimestamp).thenReturn(Timestamp.now());
      when(ac1.acid).thenReturn('mockid1');
      when(ac1.index).thenReturn(0);
      when(ac1.name).thenReturn('mock name1');
      when(ac1.link).thenReturn('https://example.com/mock_certification1.pdf');
      when(ac1.imageURL).thenReturn('http://example.com/mock_image1.jpg');
      when(ac1.source).thenReturn('mock source1');
      when(ac1.dateIssued).thenReturn(Timestamp.now());

      when(ac2.creationTimestamp).thenReturn(Timestamp.now());
      when(ac2.acid).thenReturn('mockid2');
      when(ac2.index).thenReturn(1);
      when(ac2.name).thenReturn('mock name2');
      when(ac2.link).thenReturn('https://example.com/mock_certification2.pdf');
      when(ac2.imageURL).thenReturn('http://example.com/mock_image2.jpg');
      when(ac2.source).thenReturn('mock source2');
      when(ac2.dateIssued).thenReturn(Timestamp.now());

      mockController = MockAwardCertSectionController();
    });

    group('Awards & Certification Section Widget Test on Desktop', () {
      testWidgets('Award Cert Section displays expected data on Desktop',
          (WidgetTester tester) async {
        tester.view.physicalSize = ViewPagesTestConstants.awardCertDesktopSize;
        tester.view.devicePixelRatio = 1.0;
        // Create a mock controller to provide data for the test
        when(mockController.getAwardCertList()).thenAnswer((_) async => [
              AwardCert(
                  creationTimestamp: ac1.creationTimestamp,
                  acid: ac1.acid,
                  index: ac1.index,
                  name: ac1.name,
                  imageURL: ac1.imageURL,
                  link: ac1.link,
                  source: ac1.source,
                  dateIssued: ac1.dateIssued),
              AwardCert(
                  creationTimestamp: ac2.creationTimestamp,
                  acid: ac2.acid,
                  index: ac2.index,
                  name: ac2.name,
                  imageURL: ac2.imageURL,
                  link: ac2.link,
                  source: ac2.source,
                  dateIssued: ac2.dateIssued),
            ]);

        // Build your widget with the mock controller
        await runWithNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: AwardCertSection(
                  controller: mockController,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          // Verify that the AwardCertCircle widget is displayed
          expect(find.byType(AwardCertSection), findsOneWidget);

          // Example: Verify that the title text is displayed
          expect(find.text('Awards & Certifications'), findsOneWidget);

          expect(find.byType(InkWell), findsNWidgets(2));

          expect(find.text(ac1.name as String), findsOneWidget);
          expect(find.text(ac2.name as String), findsOneWidget);

          expect(find.byType(CircleAvatar), findsNWidgets(2));

          // You can also test other aspects of your widget's behavior here.
        });
      });

      testWidgets(
          'Award Cert Circle inside of Award Cert Section works properly on Desktop',
          (WidgetTester tester) async {
        // Set the screen size to be Vertical (i.e. have a 1080x1920 aspect ratio)
        tester.view.physicalSize = ViewPagesTestConstants.awardCertDesktopSize;
        tester.view.devicePixelRatio = 1.0;
        // Create a mock controller to provide data for the test
        when(mockController.getAwardCertList()).thenAnswer((_) async => [
              AwardCert(
                  creationTimestamp: ac1.creationTimestamp,
                  acid: ac1.acid,
                  index: ac1.index,
                  name: ac1.name,
                  imageURL: ac1.imageURL,
                  link: ac1.link,
                  source: ac1.source,
                  dateIssued: ac1.dateIssued),
            ]);

        // Build your widget with the mock controller
        await runWithNetworkImages(() async {
          await tester.pumpWidget(
            MaterialApp(
              home: Material(
                child: AwardCertSection(
                  controller: mockController,
                ),
              ),
            ),
          );

          await tester.pumpAndSettle();

          expect(find.text(ac1.name as String), findsOneWidget);
          final circleAvatar = find.byType(CircleAvatar);

          expect(circleAvatar, findsOneWidget);

          final circleAvatarWidget = tester.widget<CircleAvatar>(circleAvatar);

          // Expect that the CircleAvatar has a non-null backgroundImage
          expect(circleAvatarWidget.backgroundImage, isNotNull);
          expect(
              circleAvatarWidget.backgroundImage, isInstanceOf<NetworkImage>());

          final NetworkImage backgroundImage =
              circleAvatarWidget.backgroundImage as NetworkImage;

          expect(backgroundImage.url, ac1.imageURL);

          // Test the link
          final inkWellCert = find.byType(InkWell);
          expect(inkWellCert, findsOneWidget);

          await tester.tap(inkWellCert);

          // TODO: Figure out how to test opening links
        });
      });
    });
  });
}
