import 'package:avantswift_portfolio/controller/view_controllers/landing_page_controller.dart';
import 'package:avantswift_portfolio/reposervices/user_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';

import 'landing_page_admin_controller_test.dart';
import 'landing_page_admin_controller_test.mocks.dart';

@GenerateMocks([UserRepoService, User])
void main() {
  late MockUser mockUser;
  late LandingPageController controller; // Updated class name
  late MockUserRepoService mockRepoService;

  setUp(() {
    mockUser = MockUser();
    when(mockUser.name).thenReturn('Mock User');
    when(mockUser.landingPageTitle).thenReturn('Mock Title');
    when(mockUser.landingPageDescription).thenReturn('Mock Description');
    when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');

    mockRepoService = MockUserRepoService();
    controller = LandingPageController(mockRepoService);
  });

  test('getLandingPageData returns correct data when user is not null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, mockUser.name);
    expect(landingPageData.landingPageTitle, mockUser.landingPageTitle);
    expect(landingPageData.landingPageDescription,
        mockUser.landingPageDescription);
    expect(landingPageData.imageURL, mockUser.imageURL);
  });

  test('getLandingPageData returns default data when user is null', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);
    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, 'Unknown');
    expect(landingPageData.landingPageTitle, 'Welcome');
    expect(landingPageData.landingPageDescription, 'No description available');
    expect(landingPageData.imageURL, 'https://example.com/default_image.jpg');
  });

  test('getLandingPageData returns default data when user is null', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);
    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, 'Unknown');
    expect(landingPageData.landingPageTitle, 'Welcome');
    expect(landingPageData.landingPageDescription, 'No description available');
    expect(landingPageData.imageURL, 'https://example.com/default_image.jpg');
  });
}
