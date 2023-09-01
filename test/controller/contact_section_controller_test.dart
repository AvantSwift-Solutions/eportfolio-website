import 'package:avantswift_portfolio/controller/view_controllers/contact_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';

import 'landing_page_admin_controller_test.dart';
import 'landing_page_admin_controller_test.mocks.dart';

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
    final landingPageData = await controller.getContactSectionData();

    expect(landingPageData!.name, mockUser.name);
    expect(landingPageData.contactEmail, mockUser.contactEmail);
    expect(landingPageData.linkedinURL, mockUser.linkedinURL);
  });

  test('getContactSectionData returns default data when user is null', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);
    final landingPageData = await controller.getContactSectionData();

    expect(landingPageData!.name, 'Unknown');
    expect(landingPageData.contactEmail, 'No email avaliable');
    expect(landingPageData.linkedinURL, 'No LinkedIn avaliable');
  });

  test('getContactSectionData returns error data on exception', () async {
    when(mockRepoService.getFirstUser()).thenThrow(Exception('Test Exception'));

    final landingPageData = await controller.getContactSectionData();

    expect(landingPageData!.name, 'Error');
    expect(landingPageData.contactEmail, 'Error');
    expect(landingPageData.linkedinURL, 'Error');
  });

}
