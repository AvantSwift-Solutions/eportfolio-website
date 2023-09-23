import 'package:avantswift_portfolio/constants.dart';
import 'package:avantswift_portfolio/controllers/view_controllers/contact_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'mocks/contact_section_controller_test.mocks.dart';

@GenerateMocks([UserRepoService, User])
void main() {
  late MockUser mockUser;
  late ContactSectionController controller;
  late MockUserRepoService mockRepoService;

  setUp(() {
    mockUser = MockUser();
    when(mockUser.name).thenReturn('Mock User');
    when(mockUser.contactEmail).thenReturn('Mock email');
    when(mockUser.linkedinURL).thenReturn('Mock url');

    mockRepoService = MockUserRepoService();
    controller = ContactSectionController(mockRepoService);
  });

  test('getContactSectionData returns correct data when user is not null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    final contactSectionData = await controller.getContactSectionData();

    expect(contactSectionData!.name, mockUser.name);
    expect(contactSectionData.contactEmail, mockUser.contactEmail);
    expect(contactSectionData.linkedinURL, mockUser.linkedinURL);
  });

  test('getContactSectionData returns default data when user is null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);
    final contactSectionData = await controller.getContactSectionData();

    expect(contactSectionData!.name, Constants.defaultName);
    expect(contactSectionData.contactEmail, Constants.defaultEmail);
    expect(contactSectionData.linkedinURL, Constants.defaultLinkedinURL);
  });

  test('getContactSectionData returns error data on exception', () async {
    when(mockRepoService.getFirstUser()).thenThrow(Exception('Test Exception'));

    final contactSectionData = await controller.getContactSectionData();

    expect(contactSectionData!.name, 'Error');
    expect(contactSectionData.contactEmail, 'Error');
    expect(contactSectionData.linkedinURL, 'Error');
  });

  // test('sendEmail returns true on success', () async {
  //   when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);

  //   final response = await controller.sendEmail(
  //     ContactSectionDTO(
  //       name: mockUser.name,
  //       contactEmail: 'valid_email@gmail.com',
  //       linkedinURL: mockUser.linkedinURL,
  //     ),
  //     {
  //       'from_name': 'Test Name',
  //       'from_email': 'another_valid_email@gmail.com',
  //       'message': 'Test Message',
  //     },
  //   );

  //   expect(response, true);

  // });

  // test('sendEmail returns false for invalid contactEmail', () async {
  //   when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);

  //   final response = await controller.sendEmail(
  //     ContactSectionDTO(
  //       name: mockUser.name,
  //       contactEmail: 'invalid_email',
  //       linkedinURL: mockUser.linkedinURL,
  //     ),
  //     {
  //       'from_name': 'Test Name',
  //       'from_email': 'valid_email@gmail.com',
  //       'message': 'Test Message',
  //     },
  //   );

  //   expect(response, false);

  // });
}
