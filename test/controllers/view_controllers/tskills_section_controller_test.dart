import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:avantswift_portfolio/controllers/view_controllers/technical_skills_controller.dart';

import '../admin_controllers/mocks/tskill_section_admin_controller_test.mocks.dart';
import '../admin_controllers/tskill_section_admin_controller_test.dart';

void main() {
  late MockTSkillRepoService mockRepoService;
  late TechnicalSkillsController controller;
  late MockTSkill mockTSkill;

  setUp(() {
    mockRepoService = MockTSkillRepoService();
    controller = TechnicalSkillsController(mockRepoService);
    mockTSkill = MockTSkill();
    when(mockTSkill.name).thenReturn('Name1 Name2');
    when(mockTSkill.imageURL).thenReturn('image-url-mock.com');
    when(mockTSkill.tsid).thenReturn('1');
  });

  test('getTechnicalSkillImages returns a list of Images', () async {
    // Arrange
    final tSkills = [mockTSkill];
    when(mockRepoService.getAllTSkill()).thenAnswer((_) async => tSkills);

    // Act
    final images = await controller.getTechnicalSkillImages();

    // Assert
    expect(images, isA<List<Image>>());
    expect(images.length, 1);
    expect(images[0], isA<Image>());
    expect((images[0]).image, isA<NetworkImage>());
  });

  test('getTechnicalSkillImages throws error if getting image fails', () async {
    when(mockRepoService.getAllTSkill()).thenThrow(Exception('Test Exception'));
    var expectedData = controller.getTechnicalSkillImages();
    expect(expectedData, throwsException);
  });
}
