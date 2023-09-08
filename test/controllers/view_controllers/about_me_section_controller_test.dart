import 'package:avantswift_portfolio/controllers/view_controllers/about_me_section_controller.dart';
import 'package:avantswift_portfolio/reposervice/user_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/models/User.dart';
import 'mocks/about_me_section_controller_test.mocks.dart';

@GenerateMocks([UserRepoService, User])
void main() {
  late MockUser mockUser;
  late AboutMeSectionController controller; // Updated class name
  late MockUserRepoService mockRepoService;

  setUp(() {
    mockUser = MockUser();
    when(mockUser.aboutMe).thenReturn('Mock About Me');
    when(mockUser.imageURL).thenReturn('http://example.com/mock_image.jpg');

    mockRepoService = MockUserRepoService();
    controller = AboutMeSectionController(mockRepoService);
  });

  test('getAboutMeSectionData returns correct data when user is not null',
      () async {
    when(mockRepoService.getFirstUser()).thenAnswer((_) async => mockUser);
    final aboutmeSectionData = await controller.getAboutMeSectionData();

    expect(aboutmeSectionData!.aboutMe, mockUser.aboutMe);
    expect(aboutmeSectionData.imageURL, mockUser.imageURL);
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
}
