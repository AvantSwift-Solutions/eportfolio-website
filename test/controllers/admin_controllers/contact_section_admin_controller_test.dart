import 'package:avantswift_portfolio/controllers/admin_controllers/contact_section_admin_controller.dart';
import 'package:avantswift_portfolio/dto/contact_section_dto.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';

import 'mocks/contact_section_admin_controller_test.mocks.dart';

@GenerateMocks([UserRepoService])
class MockUser extends Mock implements User {}

void main() {
  late MockUser mockUser;

  late ContactSectionAdminController controller;
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

    mockRepoService = MockUserRepoService();
    controller = ContactSectionAdminController(mockRepoService);
  });

  group('Contact Section Admin Controller tests', () {
    test('getContactSectionData returns correct data when user is not null',
        () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
      final contactSectionData = await controller.getContactSectionData();

      // Make assertions on the returned data
      expect(contactSectionData!.name, mockUser.name);
      expect(contactSectionData.contactEmail, mockUser.contactEmail);
      expect(contactSectionData.linkedinURL, mockUser.linkedinURL);
    });

    test('getContactSectionData returns default data when user is null',
        () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

      final contactSectionData = await controller.getContactSectionData();

      expect(contactSectionData!.name, 'Unknown');
      expect(contactSectionData.contactEmail, 'No email available');
      expect(contactSectionData.linkedinURL, 'No LinkedIn available');
    });

    test('getContactSectionData returns error data on exception', () async {
      when(mockRepoService.getFirstUser())
          .thenThrow(Exception('Test Exception'));

      final contactSectionData = await controller.getContactSectionData();

      expect(contactSectionData!.name, 'Error');
      expect(contactSectionData.contactEmail, 'Error');
      expect(contactSectionData.linkedinURL, 'Error');
    });

    test('updateContactSectionData returns true on successful update',
        () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
      when(mockUser.update()).thenAnswer((_) async => true);

      final updateResult = await controller.updateContactSectionData(
        ContactSectionDTO(
          name: 'New Name',
          contactEmail: 'New Email',
          linkedinURL: 'New LinkedIn',
        ),
      );

      expect(updateResult, true);
      // Doesn't update name
      verify(mockUser.contactEmail = 'New Email');
      verify(mockUser.linkedinURL = 'New LinkedIn');
      verify(mockUser.update()); // Verify that the method was called
    });

    test('updateContactSectionData returns false when user is null', () async {
      when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);

      final updateResult = await controller.updateContactSectionData(
        ContactSectionDTO(
          name: 'New Name',
          contactEmail: 'New Email',
          linkedinURL: 'New LinkedIn',
        ),
      );

      expect(updateResult, false);

      verifyNever(mockUser.update());
    });
  });
}
