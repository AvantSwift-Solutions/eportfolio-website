import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/landing_page_admin_controller.dart';
import 'package:avantswift_portfolio/dto/landing_page_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';

import 'mocks/landing_page_admin_controller_test.mocks.dart';

@GenerateMocks([UserRepoService])
class MockUser extends Mock implements User {}

void main() {
  late MockUser mockUser;

  late LandingPageAdminController controller;
  late MockUserRepoService mockRepoService;
  setUp(() {
    mockUser = MockUser(); // Replace with desired timestamp
    when(mockUser.creationTimestamp).thenReturn(Timestamp.now());
    when(mockUser.uid).thenReturn('mockUid');
    when(mockUser.email).thenReturn('mock@example.com');
    when(mockUser.name).thenReturn('Mock User');
    when(mockUser.nickname).thenReturn('Mock Title');
    when(mockUser.landingPageDescription).thenReturn('Mock Description');
    when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');
    when(mockUser.aboutMe).thenReturn('Mock About Me');

    mockRepoService = MockUserRepoService();
    controller = LandingPageAdminController(mockRepoService);
  });

  group('Landing page admin controller tests', () {
    test('getLandingPageData returns correct data when user is not null',
        () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
      final landingPageData = await controller.getLandingPageData();

      // Make assertions on the returned data
      expect(landingPageData!.name, mockUser.name);
      expect(landingPageData.nickname, mockUser.nickname);
      expect(landingPageData.landingPageDescription,
          mockUser.landingPageDescription);
      expect(landingPageData.imageURL, mockUser.imageURL);
      // Add more assertions as needed
    });

    test('getLandingPageData returns default data when user is null', () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

      final landingPageData = await controller.getLandingPageData();

      expect(landingPageData!.name, 'Unknown');
      expect(landingPageData.nickname, 'Welcome');
      expect(
          landingPageData.landingPageDescription, 'No description available');
      expect(landingPageData.imageURL, 'https://example.com/default_image.jpg');
    });

    test('getLandingPageData returns error data on exception', () async {
      when(mockRepoService.getFirstUser())
          .thenThrow(Exception('Test Exception'));

      final landingPageData = await controller.getLandingPageData();

      expect(landingPageData!.name, 'Error');
      expect(landingPageData.nickname, 'Error');
      expect(landingPageData.landingPageDescription, 'Error');
      expect(landingPageData.imageURL, 'https://example.com/error.jpg');
    });

    test('updateLandingPageData returns true on successful update', () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
      when(mockUser.update()).thenAnswer((_) async => true);

      final updateResult = await controller.updateLandingPageData(
        LandingPageDTO(
          name: 'New Name',
          nickname: 'New Title',
          landingPageDescription: 'New Description',
          imageURL: 'http://example.com/new_image.jpg',
        ),
      );

      expect(updateResult, true);
      verify(mockUser.name = 'New Name');
      verify(mockUser.nickname = 'New Title');
      verify(mockUser.landingPageDescription = 'New Description');
      verify(mockUser.imageURL = 'http://example.com/new_image.jpg');
      verify(mockUser.update()); // Verify that the method was called
    });

    test('updateLandingPageData returns false when user is null', () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

      final updateResult = await controller.updateLandingPageData(
        LandingPageDTO(
          name: 'New Name',
          nickname: 'New Title',
          landingPageDescription: 'New Description',
          imageURL: 'http://example.com/new_image.jpg',
        ),
      );

      expect(updateResult, false);

      verifyNever(mockUser.update());
    });
  });
}
