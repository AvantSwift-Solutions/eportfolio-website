import 'package:avantswift_portfolio/controllers/view_controllers/landing_page_controller.dart';
import 'package:avantswift_portfolio/dto/landing_page_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';
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

  testWidgets('LandingPage Widget Test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 1080);
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

      // Simulate a button press
      await tester.tap(find.text('Get in touch'));
      verify(mockScrollToBottom())
          .called(1); // Verify that scrollToBottom was called

      // Find the Image.network widget using a Key or another appropriate method
      final imageWidget = find.byType(Image);

      // Verify that the widget is present in the widget tree
      // Note there are 2 widgets
      // One for the actual image, and another image inside of the button widget
      expect(imageWidget, findsAtLeastNWidgets(2));

      // Unable to check if the image URL is correct
      // Because of existance of 2 image widgets
    });
  });
}
