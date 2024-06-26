import 'package:avantswift_portfolio/constants.dart';
import 'package:avantswift_portfolio/controllers/view_controllers/landing_page_controller.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'mocks/landing_page_controller_test.mocks.dart';

@GenerateMocks([UserRepoService, User])
void main() {
  late MockUser mockUser;
  late LandingPageController controller; // Updated class name
  late MockUserRepoService mockRepoService;

  setUp(() {
    mockUser = MockUser();
    when(mockUser.name).thenReturn('Name1 Name2');
    when(mockUser.nickname).thenReturn('Nick');
    when(mockUser.landingPageDescription).thenReturn('Mock Description');
    when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');

    mockRepoService = MockUserRepoService();
    controller = LandingPageController(mockRepoService);
  });

  test('getLandingPageData returns correct data when user is not null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, 'Name1');
    expect(landingPageData.nickname, 'Nick');
    expect(landingPageData.landingPageDescription,
        mockUser.landingPageDescription);
    expect(landingPageData.imageURL, mockUser.imageURL);
  });

  test('getLandingPageData returns default data when user is null', () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => null);
    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, Constants.defaultName);
    expect(landingPageData.nickname, Constants.defaultNickname);
    expect(landingPageData.landingPageDescription, 'No description available');
    expect(landingPageData.imageURL, Constants.replaceImageURL);
  });

  test('getLandingPageData returns error data on exception', () async {
    when(mockRepoService.getFirstUser()).thenThrow(Exception('Test Exception'));

    final landingPageData = await controller.getLandingPageData();

    expect(landingPageData!.name, 'Error');
    expect(landingPageData.nickname, 'Error');
    expect(landingPageData.landingPageDescription, 'Error');
    expect(landingPageData.imageURL, Constants.replaceImageURL);
  });
}
