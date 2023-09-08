import 'package:avantswift_portfolio/models/TSkill.dart';
import 'package:avantswift_portfolio/reposervice/tskill_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controller/admin_controllers/tskill_section_admin_controller.dart';
import 'mocks/tskill_section_admin_controller_test.mocks.dart';

@GenerateMocks([TSkillRepoService])
class MockTSkill extends Mock implements TSkill {}

void main() {
  late MockTSkill mockTSkill1;
  late MockTSkill mockTSkill2;

  late TSkillSectionAdminController controller;
  late MockTSkillRepoService mockRepoService;

  setUp(() {
    mockTSkill1 = MockTSkill();
    when(mockTSkill1.tsid).thenReturn('mockTsid1');
    when(mockTSkill1.name).thenReturn('Mock Tskill 1');
    when(mockTSkill1.imageURL).thenReturn('http://example.com/mock_image1.jpg');

    mockTSkill2 = MockTSkill();
    when(mockTSkill2.tsid).thenReturn('mockTsid2');
    when(mockTSkill2.name).thenReturn('Mock Tskill 2');
    when(mockTSkill2.imageURL).thenReturn('http://example.com/mock_image2.jpg');
    
    mockRepoService = MockTSkillRepoService();
    controller = TSkillSectionAdminController(mockRepoService);
  });

  test('getTSkillSectionData returns correct data when tskill is not null',
      () async {

    when(mockRepoService.getAllTSkill()).thenAnswer((_) async
      => [mockTSkill1, mockTSkill2]);
    final allTSkill = await controller.getTSkillSectionData();

    // Make assertions on the returned data
    expect(allTSkill!.length, 2);

    var tskill1 = allTSkill[0];
    var tskill2 = allTSkill[1];

    expect(tskill1.tsid, mockTSkill1.tsid);
    expect(tskill1.name, mockTSkill1.name);
    expect(tskill1.imageURL, mockTSkill1.imageURL);

    expect(tskill2.tsid, mockTSkill2.tsid);
    expect(tskill2.name, mockTSkill2.name);
    expect(tskill2.imageURL, mockTSkill2.imageURL);

  });

  test('getTSkillSectionData returns null data when tskill is null', () async {
    when(mockRepoService.getAllTSkill()).thenAnswer((_) async => null);
    final tskillSectionData = await controller.getTSkillSectionData();
    expect(tskillSectionData, null);
  });

  test('getTSkillSectionData returns null data on exception', () async {
    when(mockRepoService.getAllTSkill()).thenThrow(Exception('Test Exception'));
    final tskillSectionData = await controller.getTSkillSectionData();
    expect(tskillSectionData, null);
  });

  test('updateTSkillSectionData returns true on successful update', () async {
    when(mockRepoService.getAllTSkill()).thenAnswer((_) async
      => [mockTSkill1, mockTSkill2]);
    when(mockTSkill1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateTSkillSectionData(0,
      TSkill(
        tsid: 'mockTsid1',
        name: 'Mock Tskill 1',
        imageURL: 'http://example.com/new_mock_image1.jpg',
      ),
    );

    expect(updateResult, true);
    verify(mockTSkill1.name = 'Mock Tskill 1');
    verify(mockTSkill1.imageURL = 'http://example.com/new_mock_image1.jpg');

    verify(mockTSkill1.update()); // Verify that the method was called
  });

  test('updateTSkillSectionData returns false when user is null', () async {
    when(mockRepoService.getAllTSkill()).thenAnswer((_) async => null);

    final updateResult = await controller.updateTSkillSectionData(0,
      TSkill(
        tsid: 'mockTsid1',
        name: 'Mock Tskill 1',
        imageURL: 'http://example.com/mock_image1.jpg',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockTSkill1.update());
    verifyNever(mockTSkill2.update());
  });
}