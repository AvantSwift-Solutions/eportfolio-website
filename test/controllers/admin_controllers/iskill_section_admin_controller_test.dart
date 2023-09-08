import 'package:avantswift_portfolio/models/ISkill.dart';
import 'package:avantswift_portfolio/reposervice/iskill_repo_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/admin_controllers/iskill_section_admin_controller.dart';
import 'mocks/iskill_section_admin_controller_test.mocks.dart';

@GenerateMocks([ISkillRepoService])
class MockISkill extends Mock implements ISkill {}

void main() {
  late MockISkill mockISkill1;
  late MockISkill mockISkill2;

  late ISkillSectionAdminController controller;
  late MockISkillRepoService mockRepoService;

  setUp(() {
    mockISkill1 = MockISkill();
    when(mockISkill1.isid).thenReturn('mockIsid1');
    when(mockISkill1.name).thenReturn('Mock ISkill 1');

    mockISkill2 = MockISkill();
    when(mockISkill2.isid).thenReturn('mockIsid2');
    when(mockISkill2.name).thenReturn('Mock ISkill 2');
    
    mockRepoService = MockISkillRepoService();
    controller = ISkillSectionAdminController(mockRepoService);
  });

  test('getISkillSectionData returns correct data when iskill is not null',
      () async {

    when(mockRepoService.getAllISkill()).thenAnswer((_) async
      => [mockISkill1, mockISkill2]);
    final allISkill = await controller.getISkillSectionData();

    // Make assertions on the returned data
    expect(allISkill!.length, 2);

    var iskill1 = allISkill[0];
    var iskill2 = allISkill[1];

    expect(iskill1.isid, mockISkill1.isid);
    expect(iskill1.name, mockISkill1.name);

    expect(iskill2.isid, mockISkill2.isid);
    expect(iskill2.name, mockISkill2.name);

  });

  test('getISkillSectionData returns null data when iskill is null', () async {
    when(mockRepoService.getAllISkill()).thenAnswer((_) async => null);
    final iskillSectionData = await controller.getISkillSectionData();
    expect(iskillSectionData, null);
  });

  test('getISkillSectionData returns null data on exception', () async {
    when(mockRepoService.getAllISkill()).thenThrow(Exception('Test Exception'));
    final iskillSectionData = await controller.getISkillSectionData();
    expect(iskillSectionData, null);
  });

  test('updateISkillSectionData returns true on successful update', () async {
    when(mockRepoService.getAllISkill()).thenAnswer((_) async
      => [mockISkill1, mockISkill2]);
    when(mockISkill1.update()).thenAnswer((_) async => true);

    final updateResult = await controller.updateISkillSectionData(0,
      ISkill(
        isid: 'mockIsid1',
        name: 'Mock ISkill 1',
      ),
    );

    expect(updateResult, true);
    verify(mockISkill1.name = 'Mock ISkill 1');

    verify(mockISkill1.update()); // Verify that the method was called
  });

  test('updateISkillSectionData returns false when user is null', () async {
    when(mockRepoService.getAllISkill()).thenAnswer((_) async => null);

    final updateResult = await controller.updateISkillSectionData(0,
      ISkill(
        isid: 'mockIsid1',
        name: 'Mock ISkill 1',
      ),
    );

    expect(updateResult, false);

    verifyNever(mockISkill1.update());
    verifyNever(mockISkill2.update());
  });
}