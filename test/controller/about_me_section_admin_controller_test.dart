import 'package:avantswift_portfolio/controllers/admin_controllers/about_me_section_admin_controller.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/dto/about_me_section_dto.dart';
import 'package:avantswift_portfolio/models/User.dart';

import '../controllers/admin_controllers/mocks/about_me_section_admin_controller_test.mocks.dart';


@GenerateMocks([UserRepoService])
class MockUser extends Mock implements User {}

void main() {
  late MockUser mockUser;

  late AboutMeSectionAdminController controller;
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
    controller = AboutMeSectionAdminController(mockRepoService);
  });

  test('getAboutMeSectionData returns correct data when user is not null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    final aboutMeSectionData = await controller.getAboutMeSectionData();

    // Make assertions on the returned data
    expect(aboutMeSectionData!.aboutMe, mockUser.aboutMe);
    expect(aboutMeSectionData.imageURL, mockUser.imageURL);
    // Add more assertions as needed
  });

  test('getAboutMeSectionData returns default data when user is null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

    final aboutMeSectionData = await controller.getAboutMeSectionData();

    expect(aboutMeSectionData!.aboutMe, 'No description available');
    expect(
        aboutMeSectionData.imageURL, 'https://example.com/default_image.jpg');
  });

  test('getAboutMeSectionData returns error data on exception', () async {
    when(mockRepoService.getFirstUser()).thenThrow(Exception('Test Exception'));

    final aboutMeSectionData = await controller.getAboutMeSectionData();

    expect(aboutMeSectionData!.aboutMe, 'Error');
    expect(aboutMeSectionData.imageURL, 'https://example.com/error.jpg');
  });

  test('updateAboutMeSectionData returns true on successful update', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    when(mockUser.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateAboutMeSectionData(
      AboutMeSectionDTO(
        aboutMe: 'New About Me',
        imageURL: 'http://example.com/new_image.jpg',
      ),
    );

    expect(updateResult, true);
    verify(mockUser.aboutMe = 'New About Me');
    verify(mockUser.imageURL = 'http://example.com/new_image.jpg');
    verify(mockUser.update()); // Verify that the method was called
  });

  test('updateAboutMeSectionData returns false when user is null', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

    final updateResult = await controller.updateAboutMeSectionData(
      AboutMeSectionDTO(
        aboutMe: 'New About Me',
        imageURL: 'http://example.com/new_image.jpg',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockUser.update());
  });
}
