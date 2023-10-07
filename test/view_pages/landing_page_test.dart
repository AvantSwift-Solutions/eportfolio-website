import 'package:avantswift_portfolio/controllers/view_controllers/landing_page_controller.dart';
import 'package:avantswift_portfolio/dto/landing_page_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'package:avantswift_portfolio/ui/custom_view_button.dart';
import 'package:avantswift_portfolio/view_pages/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:run_with_network_images/run_with_network_images.dart';

import 'mocks/landing_page_test.mocks.dart';

// Create a mock for your scrollToBottom function
class MockScrollToBottom extends Mock {
  void call();
}

@GenerateMocks([User, LandingPageController])
void main() {
  late MockUser mockUser;
  late MockLandingPageController mockController; // Updated class name

  setUp(() {
    mockUser = MockUser();
    when(mockUser.name).thenReturn("MockName");
    when(mockUser.nickname).thenReturn("MockNickname");
    when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');
    when(mockUser.landingPageDescription).thenReturn('Mock Description');
    mockController = MockLandingPageController();
  });

  testWidgets('LandingPage Widget Test for Desktop',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    // Create a mock function for scrollToBottom
    final mockScrollToBottom = MockScrollToBottom();

    final mockLandingPageData = LandingPageDTO(
        name: mockUser.name,
        nickname: mockUser.nickname,
        landingPageDescription: mockUser.landingPageDescription,
        imageURL: mockUser.imageURL);
    when(mockController.getLandingPageData())
        .thenAnswer((_) => Future.value(mockLandingPageData));

    // Build the widget
    await runWithNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(
            scrollToBottom: mockScrollToBottom,
            controller: mockController,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the text elements are present
      expect(
          find.text(
              'Hey there, \nI\'m ${mockUser.name} but you \ncan call me ${mockUser.nickname}.',
              findRichText: true),
          findsOneWidget);

      expect(find.text('Get in touch'), findsOneWidget);

      // NOTE: Unable to expect and find text widget of LandingPageDescription
      expect(
          find.textContaining(mockUser.landingPageDescription as String,
              findRichText: true),
          findsOneWidget);

      expect(find.byType(CustomViewButton), findsOneWidget);
      // Simulate a button press
      await tester.tap(find.text('Get in touch'));
      verify(mockScrollToBottom())
          .called(1); // Verify that scrollToBottom was called

      expect(
          find.textContaining("Scroll down to learn more about me",
              findRichText: true),
          findsOneWidget);

      // Find the Image.network widget using a Key or another appropriate method
      final imageWidgetList = find.byType(Image);

      // Verify that the widget is present in the widget tree
      // Note there are 2 widgets
      // One for the actual image, and another image inside of the button widget
      expect(imageWidgetList, findsNWidgets(2));

      // Find the Image.network widget using a Key or another appropriate method
      final imageWidget = imageWidgetList.last;

      // You can also check other properties of the Image widget if needed
      final image = tester.widget<Image>(imageWidget);

      // Trigger a frame rebuild to ensure that the image loads
      await tester.pump();

      // You can also check if the image URL is correct (assuming _imageURL is available)
      // Replace 'your_image_url_here' with the expected image URL
      final expectedImageUrl = mockLandingPageData.imageURL;
      expect(image.image, isA<NetworkImage>());
      expect((image.image as NetworkImage).url, expectedImageUrl);
    });
  });
  testWidgets('LandingPage Widget Test for Mobile',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(500, 1140);
    tester.view.devicePixelRatio = 1.0;
    // Create a mock function for scrollToBottom
    final mockScrollToBottom = MockScrollToBottom();

    final mockLandingPageData = LandingPageDTO(
        name: mockUser.name,
        nickname: mockUser.nickname,
        landingPageDescription: mockUser.landingPageDescription,
        imageURL: mockUser.imageURL);
    when(mockController.getLandingPageData())
        .thenAnswer((_) => Future.value(mockLandingPageData));

    // Build the widget
    await runWithNetworkImages(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: LandingPage(
            scrollToBottom: mockScrollToBottom,
            controller: mockController,
          ),
        ),
      );

      // Wait for the widget to settle
      await tester.pumpAndSettle();

      // Verify that the text elements are present
      expect(
          find.text(
              'Hey there, \nI\'m ${mockUser.name} but you \ncan call me ${mockUser.nickname}.',
              findRichText: true),
          findsOneWidget);

      expect(find.text('Get in touch'), findsOneWidget);

      // NOTE: Unable to expect and find text widget of LandingPageDescription
      expect(
          find.textContaining(mockUser.landingPageDescription as String,
              findRichText: true),
          findsOneWidget);

      expect(find.byType(CustomViewButton), findsOneWidget);
      // Simulate a button press
      await tester.tap(find.text('Get in touch'));
      verify(mockScrollToBottom())
          .called(1); // Verify that scrollToBottom was called

      expect(
          find.textContaining("Scroll down to learn more about me",
              findRichText: true),
          findsNothing);
      // Verify that the widget is present in the widget tree
      // Note there are 2 widgets
      // One for the actual image, and another image inside of the button widget
      // Find the Image.network widget using a Key or another appropriate method
      final imageWidgetList = find.byType(Image);

      // Verify that the widget is present in the widget tree
      // Note there are 2 widgets
      // One for the actual image, and another image inside of the button widget
      expect(imageWidgetList, findsNWidgets(2));

      // Find the Image.network widget using a Key or another appropriate method
      final imageWidget = imageWidgetList.last;

      // You can also check other properties of the Image widget if needed
      final image = tester.widget<Image>(imageWidget);

      // Trigger a frame rebuild to ensure that the image loads
      await tester.pump();

      // You can also check if the image URL is correct (assuming _imageURL is available)
      // Replace 'your_image_url_here' with the expected image URL
      final expectedImageUrl = mockLandingPageData.imageURL;
      expect(image.image, isA<NetworkImage>());
      expect((image.image as NetworkImage).url, expectedImageUrl);
    });
  });
}
