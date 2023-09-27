import 'package:avantswift_portfolio/controllers/view_controllers/about_me_section_controller.dart';
import 'package:avantswift_portfolio/dto/about_me_section_dto.dart';
import 'package:avantswift_portfolio/view_pages/about_me_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:run_with_network_images/run_with_network_images.dart';
import 'mocks/about_me_section_test.mocks.dart';

@GenerateMocks([User, AboutMeSectionController])
void main() {
  group('AboutMeSection Widget Test', () {
    late MockUser mockUser;
    late MockAboutMeSectionController mockController; // Updated class name

    setUp(() {
      mockUser = MockUser();
      when(mockUser.aboutMe).thenReturn('Mock About Me');
      when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');
      when(mockUser.aboutMeURL)
          .thenReturn('http://example.com/mock_abt_me_image.jpg');
      mockController = MockAboutMeSectionController();
    });

    testWidgets('AboutMeSection shows expected data',
        (WidgetTester tester) async {
      final mockAboutMeSectionData = AboutMeSectionDTO(
          aboutMe: mockUser.aboutMe, imageURL: mockUser.imageURL);
      when(mockController.getAboutMeSectionData())
          .thenAnswer((_) => Future.value(mockAboutMeSectionData));

      // Build the widget
      await runWithNetworkImages(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: AboutMeSection(
              controller: mockController,
            ),
          ),
        );

        // Wait for the future to complete
        await tester.pumpAndSettle();

        // Expect to find the title text
        expect(
          find.text('A Bit About Myself...'),
          findsOneWidget,
        );

        // Expect to find the title text
        expect(
          find.text(mockUser.aboutMe as String),
          findsOneWidget,
        );

        // Find the Image.network widget using a Key or another appropriate method
        final imageWidget = find.byType(Image);

        // Verify that the widget is present in the widget tree
        expect(imageWidget, findsOneWidget);

        // You can also check other properties of the Image widget if needed
        final image = tester.widget<Image>(imageWidget);
        expect(image.width, 200);
        expect(image.height, 400);
        expect(image.fit, BoxFit.cover);

        // Trigger a frame rebuild to ensure that the image loads
        await tester.pump();

        // You can also check if the image URL is correct (assuming _imageURL is available)
        // Replace 'your_image_url_here' with the expected image URL
        final expectedImageUrl = mockUser.imageURL;
        expect(image.image, isA<NetworkImage>());
        expect((image.image as NetworkImage).url, expectedImageUrl);
      });
    });
  });
}
